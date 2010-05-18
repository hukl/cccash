class Workshift < ActiveRecord::Base
  include AASM
  aasm_column :state
  
  has_many    :transactions
  has_many    :workshift_tickets
  belongs_to  :cashbox
  belongs_to  :user
  belongs_to  :cleared_by,
              :class_name  => 'User'

  accepts_nested_attributes_for :workshift_tickets

  validates_presence_of       :user,  :cashbox, :money
  validates_numericality_of   :money, :greater_than => 0 
  validate_on_create          :no_busy_angel
  validate_on_create          :must_have_tickets
  validate_on_create          :cashbox_availability

  named_scope :in_progress, :conditions => ["state != ?", "cleared"],
                            :order      => "created_at ASC"
 
  aasm_initial_state :inactive
  
  aasm_state :inactive
  aasm_state :waiting_for_login
  aasm_state :active,   :enter => :set_started_at, :exit => :set_ended_at
  aasm_state :standby
  aasm_state :cleared,  :enter => :set_cleared_at

  aasm_event :activate do
    transitions :from => :inactive,
                :to   => :waiting_for_login
  end

  aasm_event :deactivate do
    transitions :from => :active,
                :to   => :inactive

    transitions :from => :waiting_for_login,
                :to   => :inactive

    transitions :from => :standby,
                :to   => :inactive
  end

  aasm_event :login do
    transitions :from => :waiting_for_login,
                :to   => :active

    transitions :from => :standby,
                :to   => :active

    transitions :from => :active,
                :to   => :active
  end

  aasm_event :logout do
    transitions :from => :active,
                :to   => :standby
  end

  aasm_event :clear do
    transitions :from => :inactive,
                :to   => :cleared
  end

  def set_started_at
    update_attributes! :started_at => Time.now unless started_at
  end

  def set_ended_at
    update_attributes! :ended_at => Time.now
  end

  def set_cleared_at
    update_attributes! :cleared_at => Time.now
  end
  
  def status
    state.humanize
  end

  def event_possible? requested_event
    aasm_events_for_current_state.include? requested_event
  end

  def toggle_activation
    if aasm_events_for_current_state.include?(:activate)
      activate!
    elsif aasm_events_for_current_state.include?(:deactivate)
      deactivate!
    end
  end
  
  def start!
    self.update_attributes(:started_at => Time.now)
  end
  
  def end!
    self.update_attributes(:ended_at => Time.now)
  end
  
  def grouped_tickets_count
    stats = {}
    transactions.each do |tr|
      tr.tickets.flatten.each do |tick|

        workshift_ticketss = workshift_tickets.first(
          :conditions => { :ticket_id => tick.id }
        ).try(:amount)

        stats[tick.id] ||= {}
        stats[tick.id][:ticket] ||= tick
        stats[tick.id][:total] ||= 0
        stats[tick.id][:canceled] ||= 0
        stats[tick.id][:valid] ||= 0
        stats[tick.id][(tr.canceled? ? :canceled : :valid)] += 1
        stats[tick.id][:total] += 1
        stats[tick.id][:workshift_tickets] = workshift_ticketss || 0
      end
    end
    stats
  end

  def workshift_tickets_for ticket_id
    workshift_tickets.find_by_ticket_id(ticket_id).try(:amount) || 0
  end

  def self.count_by_state
    {'active'             => 0,
     'waiting_for_login'  => 0,
     'inactive'           => 0,
     'standby'            => 0,
     'cleared'            => 0}.merge(self.count(:group => :state))
  end

  private
  def no_busy_angel
    errors.add_to_base("The user you chose is busy") if user && user.workshift
  end

  def must_have_tickets
    ticket_amount = workshift_tickets.inject(0) do |memo, wt|
      memo += wt.amount || 0
    end
    
    if ticket_amount == 0
      errors.add_to_base("You have not supplied any tickets")
    end
  end

  def cashbox_availability
    if Cashbox.busy.include? self.cashbox
      errors.add_to_base("Cashbox is already in use by other Workshift")
    end
  end
end

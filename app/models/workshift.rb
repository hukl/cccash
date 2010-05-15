class Workshift < ActiveRecord::Base
  include AASM
  aasm_column :state
  
  has_many    :transactions
  belongs_to  :cashbox
  belongs_to  :user
  belongs_to  :cleared_by,
              :class_name  => 'User'

  validates_presence_of       :user,  :cashbox, :money
  validates_numericality_of   :money, :greater_than => 0 
  validate_on_create :no_busy_angel

  named_scope :in_progress, :conditions => ["state != ?", "cleared"]
 
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
        stats[tick.id] ||= {}
        stats[tick.id][:ticket] ||= tick
        stats[tick.id][:total] ||= 0
        stats[tick.id][:canceled] ||= 0
        stats[tick.id][:valid] ||= 0
        stats[tick.id][(tr.canceled? ? :canceled : :valid)] += 1
        stats[tick.id][:total] += 1
      end
    end
    stats
  end
  
  private
  def no_busy_angel
    errors.add_to_base("The user you chose is busy") if user && user.workshift
  end
end

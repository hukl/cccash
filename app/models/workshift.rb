class Workshift < ActiveRecord::Base
  
  has_many    :transactions
  belongs_to  :cashbox
  belongs_to  :user
  
  validates_presence_of       :user,  :cashbox, :money
  validates_numericality_of   :money, :greater_than => 0
#  validates_uniqueness_of     :cashbox_id
  
  named_scope :unfinished, :conditions => { :cleared => false }
  
  
  def status
    return "waiting for login"      if started_at.blank? and active?
    return "waiting for activation" if started_at.blank?
    return "inactive"               unless active? and ended_at.blank? or cleared?
    return "active"                 if active?
    return "cleared"                if cleared? and active == false
    "popelnd"
  end
  
  def toggle_activation
    active? ? self.active = false : self.active = true
    self.save
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
  
end

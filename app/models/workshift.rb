class Workshift < ActiveRecord::Base
  
  has_many    :transactions
  belongs_to  :cashbox
  belongs_to  :user
  
  validates_presence_of       :user,  :cashbox, :money
  validates_numericality_of   :money, :greater_than => 0
  validates_uniqueness_of     :cashbox_id
  
  named_scope :unfinished, :conditions => { :cleared => false }
  
  
  def status
    return "waiting for login"      if started_at.blank? and active?
    return "waiting for activation" if started_at.blank?
    return "inactive"               unless active? and ended_at.blank? or cleared?
    return "active"                 if active?
    return "cleared"                if cleared? and active == false
    "popelnd"
  end
  
  def activate_or_deactivate options
    options.reject! { |key, value| key != "active" }
    self.update_attributes options
  end
end

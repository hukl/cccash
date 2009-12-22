class Workshift < ActiveRecord::Base
  
  belongs_to :cashbox
  belongs_to :user
  
  validates_presence_of :user, :cashbox
  
  named_scope :unfinished, :conditions => { :cleared => false }
  
  
  def status
    return "waiting for login"      if started_at.blank? and active?
    return "waiting for activation" if started_at.blank?
    return "inactive"               unless active? and ended_at.blank? or cleared?
    return "active"                 if active?
    return "cleared"                if cleared? and active == false
    "popelnd"
  end
end

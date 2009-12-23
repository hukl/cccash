class SpecialGuest < ActiveRecord::Base
  
  has_one :reservation
  has_one :ticket,          :through => :reservation

  validates_uniqueness_of   :uid,   :allow_blank => true
  validates_presence_of     :uid,   :if => Proc.new { |x| x.name.blank? and x.forename.blank? } # fail if all fields are blank

end

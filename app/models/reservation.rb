class Reservation < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :special_guest
  
end

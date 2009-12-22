class Workshift < ActiveRecord::Base
  
  belongs_to :cashbox
  belongs_to :user
  
  validates_presence_of :user, :cashbox
  
end

class Ticket < ActiveRecord::Base
  
  has_many :ticket_sales
  has_many :transactions,   :through => :ticket_sales
  
  has_many :reservations
  has_many :special_guests, :through => :reservations
  
  validates_presence_of     :name,  :price
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_uniqueness_of   :name
end

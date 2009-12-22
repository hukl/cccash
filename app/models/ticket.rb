class Ticket < ActiveRecord::Base
  
  has_many :ticket_sales
  has_many :tickets,        :through => :ticket_sales
  
  validates_presence_of     :name,  :price
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_uniqueness_of   :name
end

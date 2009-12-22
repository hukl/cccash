class Transaction < ActiveRecord::Base
  
  has_many :ticket_sales
  has_many :tickets,      :through => :ticket_sales
  
  validates_presence_of :ticket_sales, :message => "You must sell something!"
end

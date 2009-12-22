class Transaction < ActiveRecord::Base
  
  has_many    :ticket_sales
  has_many    :tickets,      :through => :ticket_sales
  belongs_to  :workshift
  
  validates_presence_of :ticket_sales, :message => "You must sell something!"
  validates_presence_of :workshift
end

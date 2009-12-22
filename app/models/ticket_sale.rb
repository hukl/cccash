class TicketSale < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :ticket
  
  validates_presence_of :ticket_id
end

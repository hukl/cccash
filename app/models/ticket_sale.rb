class TicketSale < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :ticket
end

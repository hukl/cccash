class WorkshiftTicket < ActiveRecord::Base
  
  belongs_to :workshift
  belongs_to :ticket

  validates_presence_of     :ticket, :amount
  validates_numericality_of :amount
end

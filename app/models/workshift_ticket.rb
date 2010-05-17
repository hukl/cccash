class WorkshiftTicket < ActiveRecord::Base
  
  belongs_to :workshift
  belongs_to :ticket

  validates_presence_of     :ticket, :amount
  validates_numericality_of :amount
  validate :lower_amounts,  :amount, :on => :update

  def lower_amounts
    changes = self.changes["amount"]
    unless changes && !changes.include?(nil)
      return true
    else
      errors.add_to_base "Amount is lower than before" if changes[0] > changes[1]
    end  
  end 
end

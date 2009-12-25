class Transaction < ActiveRecord::Base
  
  has_many    :ticket_sales
  has_many    :tickets,      :through => :ticket_sales
  belongs_to  :workshift
  belongs_to  :special_guest
  
  validates_presence_of :tickets, :message => "You must sell something!"
  validates_presence_of :workshift
  
  validate :transaction_contains_only_one_custom_ticket
  
  def transaction_contains_only_one_custom_ticket
    if 1 < self.tickets.custom.count
      errors.add_to_base("Only one custom ticket per transaction allowed")
    end
  end
end
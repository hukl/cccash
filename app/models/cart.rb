class Cart
  
  attr_accessor :tickets
  
  def initialize
    @tickets = []
  end
  
  def add ticket
    @tickets ||= []
    @tickets << ticket
  end
  
  def remove position
    @tickets.delete_at position
  end
  
  def total_price
    @tickets.inject(0) { |sum, ticket| sum + ticket.price }
  end
  
  def create_transaction options
    transaction = Transaction.new options
    
    @tickets.each do |ticket|
      transaction.ticket_sales.build(:ticket => ticket)
    end
    
    @tickets = []
    
    transaction
  end
  
end
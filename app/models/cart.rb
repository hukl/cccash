class Cart
  
  attr_accessor :tickets
  
  def initialize
    @tickets = []
  end
  
  def add ticket
    @tickets ||= []
    
    unless ticket.custom && ( 0 < @tickets.select { |t| t.custom? }.size )
      @tickets << ticket
    else
      false
    end
  end
  
  def remove position
    @tickets.delete_at position
  end
  
  def reset
    @tickets = []
  end
  
  def total_price
    @tickets.inject(0) { |sum, ticket| sum + ticket.price }
  end
  
  def create_transaction options
    transaction = Transaction.new options
    
    @tickets.each do |ticket|
      transaction.tickets << ticket
    end
    
    transaction.save
    transaction
  end
  
end
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
  
end
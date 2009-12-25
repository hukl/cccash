class Cart
  
  attr_accessor :tickets, :special_guest_id
  
  def initialize
    @tickets          = []
    @special_guest_id = nil
  end
  
  def add ticket
    @tickets ||= []
    
    if ticket.custom? && 0 < custom_tickets.size
      false
    else
      @tickets << ticket
    end
  end
  
  def custom_tickets
    @tickets.select { |ticket| ticket.custom }
  end
  
  def remove position
    @tickets.delete_at position
  end
  
  def reset
    @special_guest_id = nil
    @tickets = []
  end
  
  def total_price
    @tickets.inject(0) { |sum, ticket| sum + ticket.price }
  end
  
  def create_transaction options
    transaction = Transaction.new options.merge(:special_guest_id => @special_guest_id)
    
    @tickets.each do |ticket|
      transaction.tickets << ticket
    end
    
    transaction.save
    transaction
  end
  
end
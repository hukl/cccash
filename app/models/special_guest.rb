class SpecialGuest < ActiveRecord::Base
  
  has_one :reservation
  has_one :ticket,          :through => :reservation

  validates_uniqueness_of   :uid,   :allow_blank => true
  validates_presence_of     :uid,   :if => Proc.new { |special_guest| 
    # fail if all fields are blank
    special_guest.name.blank? and special_guest.forename.blank?
  }

  def assign_ticket options
    base_ticket = Ticket.find(options[:base_ticket_id])
    
    if options[:price] && options[:price] != ticket.price
      custom_ticket = find_or_create_custom_ticket(base_ticket, options[:price])
    else
      custom_ticket = base_ticket
    end
    
    self.ticket = custom_ticket
    self.save
  end

  def find_or_create_custom_ticket base_ticket, price
    custom_ticket = Ticket.custom(
      :conditions => {:name => base_ticket.name, :price => price}
    )
    
    unless custom_ticket
      custom_ticket = Ticket.create( 
        base_ticket.attributes.merge(:price => price)
      )
    else
      custom_ticket
    end
  end

end

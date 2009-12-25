class SpecialGuest < ActiveRecord::Base
  
  has_one     :reservation
  has_one     :ticket,      :through => :reservation
  belongs_to  :group

  validates_uniqueness_of   :uid,   :allow_blank => true
  validates_presence_of     :uid,   :if => Proc.new { |special_guest|
    # fail if all fields are blank
    special_guest.name.blank? and special_guest.forename.blank?
  }
  validates_presence_of     :group
  
  # Fulltext SpecialGuest Search Indexes
  
  define_index do
    indexes forename
    indexes :name
    indexes :uid
  end
  

  def assign_ticket options
    base_ticket = Ticket.find(options[:base_ticket_id])
    price       = options[:price].to_i
    
    if price && price != base_ticket.price
      custom_ticket = find_or_create_custom_ticket(base_ticket, price)
    end
    
    self.ticket = custom_ticket || base_ticket
  end

  def find_or_create_custom_ticket base_ticket, price
    custom_ticket = Ticket.find(
      :first,
      :conditions => {
        :custom => true,
        :name => base_ticket.name,
        :price => price
      }
    )
    
    unless custom_ticket
      custom_ticket = Ticket.create!(
        base_ticket.attributes.merge(:price => price, :custom => true)
      )
    end
    custom_ticket
  end

end

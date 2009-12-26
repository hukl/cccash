class Ticket < ActiveRecord::Base
  
  has_many :ticket_sales
  has_many :transactions,   :through => :ticket_sales
  
  has_many :reservations
  has_many :special_guests, :through => :reservations
  
  validates_presence_of     :name,  :price
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  
  named_scope :custom,      :conditions => {:custom => true}
  named_scope :standard,    :conditions => {:custom => false}
  named_scope :available,   :conditions => [
    "available_from < ? and ? < available_until", Time.now,Time.now
  ]
  
  def to_bon_line
    line = ''
    p = sprintf('%.2f', price)
    t = name.convert_umlauts
    line << t
    line << " " * ( Printer::BON_WIDTH - (p.length + t.length) )
    line << p
  end
end

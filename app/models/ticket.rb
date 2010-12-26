class Ticket < ActiveRecord::Base
  
  has_many :ticket_sales
  has_many :transactions,   :through => :ticket_sales
  
  has_many :reservations
  has_many :special_guests, :through => :reservations
  
  validates_presence_of     :name,  :price
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  
  named_scope :custom,      :conditions => {:custom => true}
  named_scope :standard,    :conditions => {:custom => false,:upgrade => nil,:presale => nil}
  named_scope :presale,     :conditions => {:presale => true}
  named_scope :available,   :conditions => [
    "available_from < ? and ? < available_until", Time.now,Time.now
  ]

  acts_as_list
  
  def to_bon_line
    line = ''
    p = sprintf('%.2f', price)
    t = name.convert_umlauts
    line << t
    line << " " * ( Printer::BON_WIDTH - (p.length + t.length) )
    line << p
  end
  
  def sales_grouped_by_day(fmt='%d', shift=6.hours)
    ticket_sales.group_by do |s| 
      (s.transaction.created_at-shift).strftime(fmt)
    end
  end

  def count_sales_series(start_time, end_time, step)
    TicketSale.count_time_series :start => start_time,
                                 :end   => end_time,
                                 :step  => step,
                                 :conditions => { :ticket_id => self.id }
  end
end

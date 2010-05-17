class Transaction < ActiveRecord::Base
  include Statistics

  has_many    :ticket_sales
  has_many    :tickets,      :through => :ticket_sales
  belongs_to  :workshift
  belongs_to  :special_guest
  
  validates_presence_of :tickets, :message => "You must sell something!"
  validates_presence_of :workshift
  
  validate :transaction_contains_only_one_custom_ticket
  
  def grouped_tickets
    stats = {}
    
    tickets.flatten.each do |tick|
      stats[tick.id]            ||= {}
      stats[tick.id][:ticket]   ||= tick.name
      stats[tick.id][:total]    ||= 0
      stats[tick.id][:sum]      ||= 0
      stats[tick.id][:canceled] ||= 0
      stats[tick.id][:valid]    ||= 0
      stats[tick.id][(canceled? ? :canceled : :valid)] += 1
      stats[tick.id][:total]    += 1
      stats[tick.id][:sum]      += tick.price
    end
    
    stats
  end
  
  def transaction_contains_only_one_custom_ticket
    if 1 < self.tickets.custom.count
      errors.add_to_base("Only one custom ticket per transaction allowed")
    end
  end
  
  def total
    tickets.inject(0) {|sum, ticket| sum += ticket.price}
  end
  
  def total_mwst
    
  end
  
  def cancel
    self.update_attributes(:canceled => true)
  end
  
  def total_mwst
    ((( total*19.0) / 119.0 ).round(2) )
  end
  
  def transcode_billing_address address
    
    address_lines = address.split(/\r\n/).collect {|l| "  " + l.convert_umlauts[0...Printer::BON_WIDTH-2]}
    
    (
      [ "Leistungsempfaenger:" ] +
      address_lines
    ).flatten.compact.collect {|line| line.ljust(Printer::BON_WIDTH)}
  end
  
  def to_bon billing_address="", delimiter="\n"
    (
    [
      "Chaos Communication Congress".center(Printer::BON_WIDTH),
      "26C3 - Here be dragons".center(Printer::BON_WIDTH),
      "Chaos Computer Club".center(Printer::BON_WIDTH),
      "Veranstaltungsgesellschaft mbH".center(Printer::BON_WIDTH),
      "Postfach 00 00 00".center(Printer::BON_WIDTH),
      "00000 Berlin\n".center(Printer::BON_WIDTH)
    ] +
      [transcode_billing_address(billing_address)] +
    [
      "\nTicket                                 EUR",
      "-" * Printer::BON_WIDTH,
      tickets.collect(&:to_bon_line),
      "-" * Printer::BON_WIDTH,
      sprintf( '%s %.2f', 'enthaltene MwSt', total_mwst.to_s).rjust(Printer::BON_WIDTH),
      sprintf( '%s %.2f', 'Summe:', total.to_s).rjust(Printer::BON_WIDTH),
      "=" * Printer::BON_WIDTH + "\n",
      "Leistungsdatum gleich Rechnungsdatum".center(Printer::BON_WIDTH),
      "Preise inkl. 19% MwSt".center(Printer::BON_WIDTH),
      "VIELEN DANK!\n".center(Printer::BON_WIDTH),
      "AG Charlottenburg HRB 00000".center(Printer::BON_WIDTH),
      "USt-ID: DE000000000".center(Printer::BON_WIDTH),
      (Time.now.strftime('%d. %b %Y - %H:%M ') + workshift.cashbox.name).center(Printer::BON_WIDTH),
      ("Belegnummer: " + self.id.to_s).center(Printer::BON_WIDTH)
      
      
    ]).flatten.join(delimiter) +
    Printer::END_OF_BON
  end
end

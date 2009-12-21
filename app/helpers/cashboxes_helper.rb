module CashboxesHelper
  
  def printers_for_select
    Printer.all.map {|p| [p.name, p.id]}.sort
  end
  
end

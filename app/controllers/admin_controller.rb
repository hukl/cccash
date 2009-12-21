class AdminController < ApplicationController
  
  before_filter :login_required
  
  def index
    @cashboxes  = Cashbox.all
    @printers   = Printer.all
  end
end

class AdminController < ApplicationController
  def index
    @cashboxes  = Cashbox.all
    @printers   = Printer.all
  end
end

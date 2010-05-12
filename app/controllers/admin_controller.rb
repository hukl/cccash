class AdminController < ApplicationController
  def index
    @cashboxes  = Cashbox.all
    @printers   = Printer.all
    @workshifts = Workshift.active
  end
end

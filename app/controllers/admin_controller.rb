class AdminController < ApplicationController
  def index
    @cashboxes  = Cashbox.all
    @printers   = Printer.all
    @workshifts = Workshift.in_progress
  end
end

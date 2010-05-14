class AdminController < ApplicationController

  def index
    @cashboxes  = Cashbox.all(:order => "created_at asc")
    @printers   = Printer.all
    @workshifts = Workshift.in_progress
  end

end

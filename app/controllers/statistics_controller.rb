class StatisticsController < ApplicationController
  def index
    @tickets      = Ticket.all
    @ticket_sales = TicketSale.all
  end

end

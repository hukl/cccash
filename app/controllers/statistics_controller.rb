class StatisticsController < ApplicationController
  def index
    @tickets      = Ticket.all
    @ticket_sales = TicketSale.all
    
    start_time = TicketSale.minimum(:created_at)
    end_time   = TicketSale.maximum(:created_at)

    ticket_sales_series = TicketSale.count_time_series(start_time, end_time, 'hour')
    labels = {}
    ticket_sales_series.each_with_index do |t, idx|
      labels[idx] = t.timestamp.split(' ').last if idx%6 == 0
    end
    @data = { :x_axis => 'Days',
              :y_axis => 'Sales',
              :series => { 'Sales' => ticket_sales_series.map{|t| t.count } },
              :labels => labels }
  end

end

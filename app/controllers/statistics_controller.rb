class StatisticsController < ApplicationController
  def index
    @tickets      = Ticket.all
    @ticket_sales = TicketSale.all
    
    start_time = Transaction.minimum(:created_at).to_date
    end_time   = Transaction.maximum(:created_at).to_date + 2.day
    @sales_by_day = sales_by_day(start_time, end_time)
    @sales_by_ticket = sales_by_ticket
    @transactions_by_hour = get_transactions_by_hour(1.day.ago, end_time)
  end

  private
    def sales_by_day(start_time, end_time)
      sales_series = get_sales_series_for_all_tickets(start_time, end_time, 'day')
      
      # Map the timestamp column to labels
      labels = {}
      sales_series[Ticket.first.name].each_with_index do |t, idx|
        labels[idx.to_i] = t.timestamp.to_date.strftime("%d.%m.%y")

      end

      # Map the count columns of each series
      data = {}
      sales_series.each do |name, series|
        data[name] = series.map{ |t| t.count.to_i }
      end

      return { :x_axis => 'Days',
               :y_axis => 'Sales',
               :series => data,
               :labels => labels }
    end
   
    def sales_by_ticket
      sales = TicketSale.count :group => :ticket_id
      
      # Map the count
      data = {}
      Ticket.all.each do |ticket|
        data[ticket.name] = sales[ticket.id]
      end

      return { :series => data }
    end

    def get_sales_series_for_all_tickets(start_time, end_time, step)
      series = {}
      Ticket.all.each do |ticket|
        series[ticket.name] = ticket.count_sales_series(start_time, end_time, step)
       end
      series
    end

    def get_transactions_by_hour(start_time, end_time)
      transactions = Transaction.count_time_series(:start => start_time,
                                                   :end   => end_time,
                                                   :step  => 'hour')
      # Map the timestamp column to labels
      labels = {}
      transactions.each_with_index do |t, idx|
        time = t.timestamp.to_time
        if time.hour == 0
          labels[idx.to_i] = time.strftime("%d.%m.%y")
        elsif time.hour%4 == 0
          labels[idx.to_i] = time.hour
        end
      end

      # Map the count columns of each series
      data = transactions.map{ |t| t.count.to_i }

      return { :x_axis => 'Days',
               :y_axis => 'Sales',
               :series => {'Transactions' => data},
               :labels => labels }

    end
    

end

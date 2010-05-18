class AdminController < ApplicationController

  def index
    @cashboxes  = Cashbox.all(:order => "created_at asc")
    @printers   = Printer.all
    @workshifts = Workshift.in_progress
    @transactions_by_minute = get_transactions_by_minute(30.minutes.ago, Time.now)
    @workshift_count = Workshift.count_by_state
  end

  private
    def get_transactions_by_minute(start_time, end_time)
      transactions = Transaction.count_time_series(:start => start_time,
                                                   :end   => end_time,
                                                   :step  => 'minute')
      # Map the timestamp column to labels
      labels = {}
      transactions.each_with_index do |t, idx|
        time = t.timestamp.to_time
        if time.min == 0
          labels[idx.to_i] = time.strftime("%H:%M")
        elsif time.min%5 == 0
          labels[idx.to_i] = time.strftime("%M")
        end
      end

      # Map the count columns of each series
      data = transactions.map{ |t| t.count.to_i }

      return { :series => {'Transactions' => data},
               :labels => labels }
    end
end

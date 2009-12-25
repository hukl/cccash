class Cashbox < ActiveRecord::Base

  has_one     :workshift
  belongs_to  :printer

  validates_presence_of   :ip,    :port, :name, :printer_id
  validates_format_of     :ip,    :with => /^(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/
  validates_inclusion_of  :port,  :in => 1..65536
  validates_uniqueness_of :ip, :name

  named_scope(
    :busy,
    :joins => :workshift,
    :conditions => ["workshifts.cashbox_id = cashboxes.id"]
  )
  
  def open_drawer
    cashbox_response_for('/open').match(/open/) != nil
  end
  
  def wait_for_closed_drawer
    cashbox_response_for('/wait_for_close',180).match(/closed/) != nil
  end
  
  def cashbox_response_for( url, timeout=5)
    begin
      http = Net::HTTP.new(ip, port)
      http.read_timeout = timeout
      response, data = http.get( url, nil )
      return data
    rescue Errno::ECONNREFUSED
      raise NotFound, "Cashbox refused connection: #{url(request_uri)}"
    rescue Timeout::Error
      raise NotFound, "Cashbox did not respond (timeout): #{url(request_uri)}"
    rescue Net::HTTPExceptions => e
      raise Borken, "Cashbox has fundamental issues: #{e}"
    end
  end
end


__END__

TODO Review code snippet in case of shitty behavior
  
The reinit code could be useful one day

=> return response_for('/reinit', 10, 0)

apparently the original c daemon returned a "vanished" status if the cashbox
wasn't responding at all
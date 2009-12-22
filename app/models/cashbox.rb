class Cashbox < ActiveRecord::Base

  has_one :workshift

  validates_presence_of   :ip,    :port, :name, :printer_id
  validates_format_of     :ip,    :with => /^(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/
  validates_inclusion_of  :port,  :in => 1..65536
  validates_uniqueness_of :ip, :name

  named_scope(
    :busy,
    :joins => :workshift,
    :conditions => ["workshifts.cashbox_id = cashboxes.id"]
  )
end
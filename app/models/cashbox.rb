class Cashbox < ActiveRecord::Base
  validates_presence_of   :ip,    :port, :name
  validates_format_of     :ip,    :with => /^(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/
  validates_inclusion_of  :port,  :in => 1..65536
  validates_uniqueness_of :ip, :name
end
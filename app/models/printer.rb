class Printer < ActiveRecord::Base
  
  has_many :cashboxes
  
  BON_WIDTH = 42
  END_OF_BON = ("\r\n"*8) + "\x1D\x561"
  
  validates_uniqueness_of :name, :cups_name
  
  def print(data)
    if Rails.env == "production"
      IO.popen("/usr/bin/lpr -P #{cups_name}", 'w+') do |m|
        m.puts data
      end
    else
      logger.info data
    end
  end
end

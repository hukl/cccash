class Printer < ActiveRecord::Base
  validates_uniqueness_of :name, :cups_name
end

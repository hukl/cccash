require 'test_helper'

class PrinterTest < ActiveSupport::TestCase
  test "printer name must be unique" do
    assert_raise ActiveRecord::RecordInvalid do
      Printer.create! :name => "Dummy Printer 1"
    end
  end
  
  test "printer cups name must be unique" do
    assert_raise ActiveRecord::RecordInvalid do
      Printer.create! :cups_name => "dummy_printer_1"
    end
  end
end

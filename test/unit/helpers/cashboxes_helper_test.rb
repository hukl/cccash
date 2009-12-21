require 'test_helper'

class CashboxesHelperTest < ActionView::TestCase
  
  test "printers_for_select return name id tuples" do
    expected = [["Dummy Printer 1", 1], ["Dummy Printer 2", 2]]
    assert_equal expected, printers_for_select
  end
end

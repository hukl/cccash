require 'test_helper'

class ReservationTest < ActiveSupport::TestCase

  test "reservation has ticket association" do
    assert_nothing_raised { reservations(:one).ticket }
  end
  
  test "reservation has special_guest association" do
    assert_nothing_raised { reservations(:one).special_guest }
  end
end

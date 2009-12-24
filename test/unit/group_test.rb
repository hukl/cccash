require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  test "groups have special_guests association" do
    assert_nothing_raised { groups(:one).special_guests }
  end
  
end

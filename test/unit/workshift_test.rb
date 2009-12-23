require 'test_helper'

class WorkshiftTest < ActiveSupport::TestCase
  
  test "workshift has cashbox" do
    assert_nothing_raised { workshifts(:one).cashbox }
  end
  
  test "workshift has user" do
    assert_nothing_raised { workshifts(:one).user }
  end
  
  test "workshift has transactons" do
    assert_nothing_raised { workshifts(:one).transactions }
  end
  
  test "workshift must have an user assigned" do
    workshift = Workshift.new :cashbox => cashboxes(:one)
    assert_equal false, workshift.valid?, "Workshift should not be valid"
    assert workshift.errors.invalid?(:user)
  end
  
  test "workshift must have a cashbox" do
    workshift = Workshift.new :user => users(:quentin)
    assert_equal false, workshift.valid?, "Workshift should not be valid"
    assert workshift.errors.invalid?(:cashbox)
  end
  
  test "workshift must have initial ammount of money assigned" do
    workshift = Workshift.new(
      :user     => users(:quentin),
      :cashbox  => cashboxes(:one)
    )
    assert_equal false, workshift.valid?, "Workshift should not be valid"
    assert workshift.errors.invalid?(:money)
  end
  
  test "workshift money must be a number greater than 0" do
    workshift = Workshift.new(
      :user     => users(:quentin),
      :cashbox  => cashboxes(:one),
      :money    => -100
    )
    
    assert_equal false, workshift.valid?, "Workshift should not be valid"
    assert workshift.errors.invalid?(:money)
  end
  
  test "workshift must have unique cashbox_id" do
    workshift = Workshift.new(
      :user     => users(:quentin),
      :cashbox  => cashboxes(:one),
      :money    => 800
    )
    
    assert_equal false, workshift.valid?, "Workshift should not be valid"
    assert workshift.errors.invalid?(:cashbox_id)
  end
  
end

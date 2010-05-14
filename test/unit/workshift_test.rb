require 'test_helper'

class WorkshiftTest < ActiveSupport::TestCase
  
  test "workshift inital state" do
    my_workshift = Workshift.create :user_id    => 1,
                                    :cashbox_id => 1,
                                    :money      => 23
    assert_not_nil my_workshift, "Creation failed"
    assert_equal 'inactive', my_workshift.state
  end
  
  test "login and logout callbacks" do
    my_workshift = Workshift.create :user_id    => 1,
                                    :cashbox_id => 1,
                                    :money      => 23
    my_workshift.activate!
    assert_equal "waiting_for_login", my_workshift.state
    my_workshift.login!
    assert_not_nil my_workshift.started_at
    assert my_workshift.started_at < Time.now && my_workshift.started_at > 1.seconds.ago
    my_started_at = my_workshift.started_at
    
    my_workshift.deactivate!
    assert_not_nil my_workshift.ended_at
    assert my_workshift.ended_at < Time.now && my_workshift.ended_at > 1.seconds.ago
    
    my_workshift.activate!
    assert_equal my_started_at, my_workshift.started_at
  end

  test "clear callbacks" do
    my_workshift = Workshift.create :user_id    => 1,
                                    :cashbox_id => 1,
                                    :money      => 23
    my_workshift.activate!
    my_workshift.login!
    my_workshift.deactivate!
    my_workshift.clear!
    assert_not_nil my_workshift.cleared_at
    assert my_workshift.cleared_at < Time.now && my_workshift.cleared_at > 1.seconds.ago
  end

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
end

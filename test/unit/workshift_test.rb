require 'test_helper'

class WorkshiftTest < ActiveSupport::TestCase

  test "activating two workshifts with the same cashbox should not work" do
    Workshift.delete_all
    workshift_a = Workshift.create!(
      :user     => users(:aaron),
      :money    => 200,
      :cashbox  => cashboxes(:five),
      :workshift_tickets_attributes => [
        { :ticket_id  => 1, :amount => 20 }
      ]
    )

    expexted_message = "Cashbox is already in use by other Workshift"
    assert_raise(ActiveRecord::RecordInvalid, expexted_message) do
      workshift_b = Workshift.create!(
        :user     => users(:yesper),
        :money    => 200,
        :cashbox  => cashboxes(:five),
        :workshift_tickets_attributes => [
          { :ticket_id  => 1, :amount => 20 }
        ]
      )
    end
  end

  test "no workshift without tickets" do
    workshift = Workshift.new :user    => users(:no_workshift_dude),
                              :money   => 123,
                              :cashbox => cashboxes(:one)
    assert_equal false, workshift.valid?, "Workshift should not be valid"
  end

  test "no workshifts for busy angels" do
    my_workshift = workshifts(:three)
    
    my_user = User.create! :password              => 'foobar',
                           :password_confirmation => 'foobar',
                           :login                 => 'busy_angel'

    workshift_one = my_user.workshifts.create :cashbox => Cashbox.first,
                                              :money   => 123
    assert_not_nil workshift_one, "First workshift creation failed"
    
    workshift_two = my_user.workshifts.new :cashbox => Cashbox.first,
                                           :money   => 123
    assert_equal false, workshift_two.valid?, "Workshift should not be valid"
  end

  test "workshift inital state" do
    my_workshift = workshifts(:three)
    assert_not_nil my_workshift, "Creation failed"
    assert_equal 'inactive', my_workshift.state
  end
  
  test "login and logout callbacks" do
    my_workshift = workshifts(:four)
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
    my_workshift = workshifts(:four)
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

require 'test_helper'

class WorkshiftsControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
  end

  test "create new workshift with cashbox_tickets" do
    WorkshiftTicket.delete_all

    assert_difference "WorkshiftTicket.count", +2 do
      post(
        :create,
          :workshift => {
            :cashbox  => cashboxes(:four),
            :user     => users(:no_workshift_dude),
            :money    => 800,
            :workshift_tickets_attributes => [
              {:ticket_id => 1, :amount => 20 },
              {:ticket_id => 2, :amount => 40 }
            ]
        }
      )
    end
    assert_equal 1,   WorkshiftTicket.first.ticket_id
    assert_equal 20,  WorkshiftTicket.first.amount
    assert_equal 2,   WorkshiftTicket.last.ticket_id
    assert_equal 40,  WorkshiftTicket.last.amount
  end

  test "creatin a new workshift with invalid workshift_tickets should fail" do
    assert_no_difference "WorkshiftTicket.count" do
      post(
        :create,
          :workshift => {
            :cashbox  => cashboxes(:four),
            :user     => users(:no_workshift_dude),
            :money    => 800,
            :workshift_tickets_attributes => [
              {:ticket_id => 1, :amount => "" },
              {:ticket_id => 2, :amount => 40 }
            ]
        }
      )
    end
  end
    
  test "updating workshift_tickets on workshift" do
    put(
      :update,
      :id => 1,
      :workshift => {
        :cashbox  => cashboxes(:four),
        :user     => users(:no_workshift_dude),
        :money    => 800,
        :workshift_tickets_attributes => [
          {:id => 1, :ticket_id => 1, :amount => 23 },
          {:id => 2, :ticket_id => 2, :amount => 42 }
        ]
      }
    )

    assert_equal 23, WorkshiftTicket.find(1).amount
    assert_equal 42, WorkshiftTicket.find(2).amount
  end

  test "updating workshift_tickets with lower amount shouldn not work" do

    assert_no_difference "WorkshiftTicket.find(1).amount" do
      put(
        :update,
        :id => 1,
        :workshift => {
          :cashbox  => cashboxes(:four),
          :user     => users(:no_workshift_dude),
          :money    => 800,
          :workshift_tickets_attributes => [
            {:id => 1, :ticket_id => 1, :amount => 5 },
            {:id => 2, :ticket_id => 2, :amount => 1 }
          ]
        }
      )
    end
  end

  test "get index" do
    get :index
    assert_response :success
  end
  
  test "get billing" do
    get :billing, :id => 1
    assert_response :success
  end
  
  test "get new" do
    get :new
    assert_response :success
  end
  
  test "create new workshift" do
    assert_difference "Workshift.count", +1 do
      post :create, :workshift => {
        :cashbox  => cashboxes(:four),
        :user     => users(:no_workshift_dude),
        :money    => 100,
        :workshift_tickets_attributes => [
          {:ticket_id => 1, :amount => 20 },
          {:ticket_id => 2, :amount => 40 }
        ]
      }
    end
    
    assert_redirected_to admin_path
    assert_equal 4, Workshift.last.cashbox_id
    assert_equal "nwsd", Workshift.last.user.login
  end
  
  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end
  
  test "update a workshift" do
    put :update, :id => 1, :workshift => {
      :cashbox  => cashboxes(:four),
      :user     => users(:yesper)
    }
    
    workshift = Workshift.find(1)
    assert_redirected_to admin_path
    assert_equal 4, workshift.cashbox_id
    assert_equal "yesper", workshift.user.login
  end
  
  test "destroying a workshift" do
    assert_difference "Workshift.count", -1 do
      delete :destroy, :id => 1
    end
    assert_redirected_to admin_path
  end
  
  test "activating a workshift" do
    assert_equal "inactive", Workshift.find(3).state
    put :toggle_activation, :id => 3, :format => "js"
    assert_response :success
    assert_equal "waiting_for_login", Workshift.find(3).state
  end
  
  test "deactivating a workshift" do
    assert_equal true, Workshift.find(2).active?
    put :toggle_activation, :id => 2, :format => "js"
    assert_response :success
    assert_equal false, Workshift.find(2).active?
  end

  test "clearing a workshift" do
    my_workshift = Workshift.find(1)
    assert !my_workshift.cleared?, "Workshift shouldn't be cleared at this point"
    assert !my_workshift.cleared_at, "Workshift shouldn't be cleared at this point"
    
    put   :toggle_activation, :id => 1, :format => "js"
    post  :clear, :id => 1
    
    assert_redirected_to admin_path
    my_workshift = Workshift.find(1)
    assert_equal "cleared", my_workshift.state, "Workshift not marked as cleared"
    assert_not_nil my_workshift.cleared_at, "Timestamp of clearance is nil"
    assert_equal users(:quentin).id, my_workshift.cleared_by_id, "Workshift not cleared by quentin"
  end
end

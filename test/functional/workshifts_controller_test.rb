require 'test_helper'

class WorkshiftsControllerTest < ActionController::TestCase
  
  test "get index" do
    get :index
    assert_response :success
  end
  
  test "get new" do
    get :new
    assert_response :success
  end
  
  test "create new workshift" do
    assert_difference "Workshift.count", +1 do
      post :create, :workshift => {
        :cashbox  => cashboxes(:one),
        :user     => users(:aaron)
      }
    end
    
    assert_redirected_to admin_path
    assert_equal 1, Workshift.last.cashbox_id
    assert_equal "aaron", Workshift.last.user.login
  end
  
  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end
  
  test "update a workshift" do
    put :update, :id => 1, :workshift => {
      :cashbox  => cashboxes(:two),
      :user     => users(:yesper)
    }
    
    workshift = Workshift.find(1)
    assert_redirected_to admin_path
    assert_equal 2, workshift.cashbox_id
    assert_equal "yesper", workshift.user.login
  end
  
  test "destroying a workshift" do
    assert_difference "Workshift.count", -1 do
      delete :destroy, :id => 1
    end
    assert_redirected_to admin_path
  end
end

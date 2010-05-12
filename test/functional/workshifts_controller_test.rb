require 'test_helper'

class WorkshiftsControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
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
        :user     => users(:aaron),
        :money    => 100
      }
    end
    
    assert_redirected_to admin_path
    assert_equal 4, Workshift.last.cashbox_id
    assert_equal "aaron", Workshift.last.user.login
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
    assert_equal false, Workshift.find(3).active?
    put :toggle_activation, :id => 3, :format => "js"
    assert_response :success
    assert_equal true, Workshift.find(3).active?
  end
  
  test "deactivating a workshift" do
    assert_equal true, Workshift.find(2).active?
    put :toggle_activation, :id => 2, :format => "js"
    assert_response :success
    assert_equal false, Workshift.find(2).active?
  end
end

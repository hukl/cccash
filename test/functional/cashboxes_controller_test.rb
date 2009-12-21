require 'test_helper'

class CashboxesControllerTest < ActionController::TestCase
  
  test "get index" do
    get :index
    assert_response :success
  end
  
  test "get new" do
    get :new
    assert_response :success
  end
  
  test "create new cashbox" do
    assert_difference "Cashbox.count", +1 do
      post :create, :cashbox => {
        :ip         => "23.23.23.1", 
        :port       => 2342, 
        :name       => "Cashbox 1", 
        :printer_id => 1
      }
    end
    
    cashbox = Cashbox.last
    
    assert_equal "23.23.23.1", cashbox.ip
    assert_equal 2342, cashbox.port
    assert_equal "Cashbox 1", cashbox.name
    assert_equal 1, cashbox.printer_id
    assert_redirected_to admin_path
  end
  
  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end
  
  test "update a cashbox" do
    put :update, :id => 1, :cashbox => {
      :ip         => "23.23.23.2", 
      :port       => 4223, 
      :name       => "Cashbox 2", 
      :printer_id => 2
    }
    
    assert_redirected_to admin_path
    
    cashbox = Cashbox.find(1)
    assert_equal "23.23.23.2", cashbox.ip
    assert_equal 4223, cashbox.port
    assert_equal "Cashbox 2", cashbox.name
    assert_equal 2, cashbox.printer_id
  end
  
  test "destroying a cashbox" do
    assert_difference "Cashbox.count", -1 do
      delete :destroy, :id => 1
    end
    
    assert_redirected_to admin_path
  end
  
  
end

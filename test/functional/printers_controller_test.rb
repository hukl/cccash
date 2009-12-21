require 'test_helper'

class PrintersControllerTest < ActionController::TestCase
  
  test "get index" do
    get :index
    assert_response :success
  end
  
  test "get new" do
    get :new
    assert_response :success
  end
  
  test "create new printer" do
    assert_difference "Printer.count", +1 do
      post :create, :printer => {:name => "Printer 1", :cups_name => "printer1"}
    end
  end
  
  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end
  
  test "update a printer" do
    put :update, :id => 1, :printer => { :name => "Bon Printer 1" }
    
    assert_redirected_to admin_path
    assert_equal "Bon Printer 1", Printer.find(1).name
  end
  
  test "destroying a printer" do
    assert_difference "Printer.count", -1 do 
      delete :destroy, :id => 1
    end
    
    assert_redirected_to admin_path
  end
  
end

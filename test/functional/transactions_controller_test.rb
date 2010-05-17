require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  
  test "get index" do
    login_as :quentin
    
    get :index
    assert_response :success
  end
  
end

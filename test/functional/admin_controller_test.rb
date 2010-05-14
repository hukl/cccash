require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  def setup
    login_as :quentin
  end

  test "get admin page" do
    get :index
    assert_response :success
  end

  test "angel should not be able to access admin controller" do
    login_as :aaron
    get :index
    assert_response 401
  end
end

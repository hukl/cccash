require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  def setup
    login_as :quentin
  end

  test "get admin page" do
    get :index
    assert_response :success
  end
end

require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test "get admin page" do
    get :index
    assert_response :success
  end
end

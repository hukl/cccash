require 'test_helper'

class SpecialGuestsControllerTest < ActionController::TestCase

  test "get index" do
    get :index
    assert_response :success
  end
  
  test "get new" do
    get :new
    assert_response :success
  end
  
  test "create special guest with regular ticket" do
    assert_difference "Reservation.count", +1 do
      post :create, 
      :special_guest => {
        :forename   => "Peter",
        :name       => "fnord",
        :uid        => "2342foo",
      },
      :ticket => {
        :base_ticket_id => 1
      }
    end
    
    assert_response :success
  end
end

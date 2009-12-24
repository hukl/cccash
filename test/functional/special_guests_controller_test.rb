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
        :group_id => 1
      },
      :ticket => {
        :base_ticket_id => 1
      }
    end
    
    assert_response :redirect
  end
  
  test "create special guest with custom ticket" do
    assert_difference "Reservation.count", +1 do
      post :create,
      :special_guest => {
        :forename   => "Peter",
        :name       => "fnord",
        :uid        => "2342foo",
        :group_id   => 1
      },
      :ticket => {
        :base_ticket_id => 1,
        :price => 40
      }
    end
    
    assert_response :redirect
  end
end

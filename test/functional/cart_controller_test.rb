require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  
  def setup
    login_as :yesper
  end
  
  test "cart has an empty tickets array" do
    get :show
    assert_response :success
    assert_equal [], session[:cart].tickets
  end
  
  test "adding a ticket to the cart" do
    put :add_ticket_to, :id => tickets(:one).id
    assert_response :success
    assert_equal 1, session[:cart].tickets.size
  end
  
  test "adding multiple tickets to the cart and delete one" do
    get :show
    
    session[:cart].tickets << tickets(:one)
    session[:cart].tickets << tickets(:two)
    session[:cart].tickets << tickets(:one)
    
    delete :remove_ticket_from, :position => 1  # equals ticket :two in the cart
    assert_response :success
    assert_equal 2, session[:cart].tickets.size
    assert_equal [1,1], session[:cart].tickets.map {|t| t.id} # 2x Dummy ticket 1
    assert_select( "#cart table tr td", "Dummy ticket 1" )
  end
end

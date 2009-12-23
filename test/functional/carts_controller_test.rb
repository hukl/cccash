require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  
  def setup
    login_as :aaron
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
  
  test "checking out an empty cart should not work" do
    session[:cart] ||= Cart.new
    
    assert_no_difference "Transaction.count" do
      get :checkout
    end
    
    assert_redirected_to cart_path
    
    expected = "Invalid Transaction: You must sell something!"
    assert_equal expected, flash[:notice]
    assert_equal [], session[:cart].tickets
  end
  
  test "checking out a valid cart" do
    create_valid_shopping_cart
    
    assert_difference "Transaction.count", +1 do
      get :checkout
    end
    
    transaction = Transaction.last
    assert_response   :success
    assert_template   :checkout
    assert_equal 2, transaction.tickets.count
    assert_equal users(:aaron).workshift, transaction.workshift
    
    ticket_names = ["Dummy ticket 1", "Dummy ticket 2"]
    assert_equal ticket_names, transaction.tickets.map {|t| t.name}
  end
  
  test "reloading :show action empties cart" do
    create_valid_shopping_cart
    get :show
    assert_equal 0, session[:cart].tickets.count
  end
  
  def create_valid_shopping_cart
    session[:cart] ||= Cart.new
    session[:cart].tickets << tickets(:one)
    session[:cart].tickets << tickets(:two)
  end
end

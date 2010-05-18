require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  
  def setup
    login_as :aaron
    @request.env['REMOTE_ADDR'] = '42.42.42.2'
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
  
  test "adding a custom ticket sets special_guest_id on transaction" do
    put :add_ticket_to, :id => tickets(:two).id, :special_guest_id => 2
    assert_response :success
    
    assert_difference "Transaction.count", +1 do
      get :checkout
    end
    
    assert_equal 2, Transaction.last.special_guest_id
  end
  
  test "special_guest_id will not be overwritten" do
    put :add_ticket_to, :id => tickets(:two).id, :special_guest_id => 2
    put :add_ticket_to, :id => tickets(:one).id
    assert_response :success
    
    assert_difference "Transaction.count", +1 do
      get :checkout
    end
    
    assert_equal 2, Transaction.last.special_guest_id
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
    assert_equal ticket_names, transaction.tickets.map {|t| t.name}.sort
    assert_equal [], session[:cart].tickets
    assert_nil session[:cart].special_guest_id
  end
  
  test "reloading :show action empties cart" do
    create_valid_shopping_cart
    get :show
    assert_equal 0, session[:cart].tickets.count
  end
  
  test "cancel a transaction" do
    assert_not_nil transaction = create_valid_transaction(users(:aaron).workshift)
    assert transaction.valid?
    assert_equal false, !!transaction.canceled
    post(
      :confirm_cancel,
      :login => "quentin",
      :password => "monkey",
      :transaction_id => transaction.id
    )
    
    assert transaction.reload.canceled
  end
  
  def create_valid_transaction workshift
    transaction = Transaction.new( :workshift => workshift )
    transaction.tickets << tickets(:one)
    transaction.save
    transaction
  end
  
  def create_valid_shopping_cart
    session[:cart] ||= Cart.new
    session[:cart].tickets << tickets(:one)
    session[:cart].tickets << tickets(:two)
  end
end

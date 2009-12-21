require 'test_helper'

class TicketsControllerTest < ActionController::TestCase

  test "get index" do
    get :index
    assert_response :success
  end

  test "get new" do
    get :new
    assert_response :success
  end

  test "create new ticket" do
    #TODO: really create a ticket
  end

  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end

  test "deleting a ticket type" do
    #TODO: really delete the ticket
    #assert_difference "Ticket.count", -1 do
    #  delete :destroy, :id => 1
    #end

    #assert_redirected_to tickets_path
  end

end

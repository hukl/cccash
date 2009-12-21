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
    assert_difference "Ticket.count", +1 do
      post :create, :ticket => {
        :name     => "standard",
        :price    => 2342,
        :comment  => "foobar fnord",
        :custom   => true,
      }
    end

    ticket = Ticket.last

    assert_equal "standard", ticket.name
    assert_equal 2342, ticket.price
    assert_equal "foobar fnord", ticket.comment
    assert_equal true, ticket.custom
    assert_redirected_to tickets_path
  end

  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end

  test "update a ticket" do
    put :update, :id => 1, :ticket => {
        :name     => "standard",
        :price    => 2342,
        :comment  => "foobar fnord",
        :custom   => true,
    }

    assert_redirected_to tickets_path

    ticket = Ticket.find(1)
    assert_equal "standard", ticket.name
    assert_equal 2342, ticket.price
    assert_equal "foobar fnord", ticket.comment
    assert_equal true, ticket.custom
    assert_redirected_to tickets_path
  end

  test "deleting a ticket type" do
    assert_difference "Ticket.count", -1 do
      delete :destroy, :id => 1
    end

    assert_redirected_to tickets_path
  end

end

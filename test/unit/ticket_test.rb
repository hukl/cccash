require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "ticket must have a name" do
    assert_raise ActiveRecord::RecordInvalid do
      Ticket.create! :price => 0
    end
  end
  
  test "ticket must have a price" do
    assert_raise ActiveRecord::RecordInvalid do
      Ticket.create! :name => "foobar fnord"
    end
  end

  test "ticket price must be greater or equal than zero" do
    assert_raise ActiveRecord::RecordInvalid do
      Ticket.create! :name => "foobar fnord", :price => "x"
    end
  end

  test "ticket name must be unique" do
    assert_raise ActiveRecord::RecordInvalid do
      Ticket.create! :name => "Dummy ticket 1", :price => 2342
    end
  end
  
  test "ticket has ticket_sales method" do
    assert_nothing_raised { tickets(:one).ticket_sales }
  end
  
  test "ticket has transactions method" do
    assert_nothing_raised { tickets(:one).tickets }
  end
end

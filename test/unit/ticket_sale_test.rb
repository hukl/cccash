require 'test_helper'

class TicketSaleTest < ActiveSupport::TestCase
  
  test "ticket sale must belong to a ticket" do
    ticket_sale = TicketSale.new
    assert_equal false, ticket_sale.valid?
    assert ticket_sale.errors.invalid?(:ticket_id)
  end
  
end

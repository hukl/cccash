require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  
  test "transaction has ticket_sales" do
    assert_nothing_raised do
      transactions(:one).ticket_sales
    end
  end
  
  test "transaction has tickets" do
    assert_nothing_raised do
      transactions(:one).tickets
    end
  end
  
  test "transaction must have at least one ticket sale" do
    transaction = Transaction.new
    
    assert_raise ActiveRecord::RecordInvalid do
      transaction.save!
    end
    
    transaction.save
    transaction.errors.include?(:ticket_sales)
  end
  
  test "builing a transaction with ticket sale" do
    transaction = Transaction.new
    transaction.ticket_sales.build :ticket => tickets(:one)
    assert transaction.save
    assert_equal 1, transaction.tickets.count
    assert_equal 1, transaction.ticket_sales.count
    assert_equal "Dummy ticket 1", transaction.tickets.first.name
  end
end
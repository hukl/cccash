require 'test_helper'

class CashboxTest < ActiveSupport::TestCase
  
  test "cashbox must have an ip" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :port => 2342, :name => "Foo", :printer_id => 1
    end
  end
  
  test "cashbox must have a port" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "2.3.4.2", :name => "Foo", :printer_id => 1
    end
  end
  
  test "cashbox must have a name" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "2.3.4.2", :port => 2342, :printer_id => 1
    end
  end
  
  test "ip must have a valid format" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "2.3.4-2", :port => 2342, :name => "a", :printer_id => 1
    end
  end
  
  test "port number must not exceed 65536" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "2.3.4.2", :port => 65537, :name => "a", :printer_id => 1
    end
  end
  
  test "port number must be greater than 0" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "2.3.4.2", :port => 0, :name => "a", :printer_id => 1
    end
  end
  
  test "ip must be unique" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "42.42.42.1", :port => 23, :name => "a", :printer_id => 1
    end
  end
  
  test "name must be unique" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "42.42.42.42", :port => 23, :name => "Dummy Cashbox 1", :printer_id => 1
    end
  end
  
  test "cashbox must have a printer" do
    assert_raise ActiveRecord::RecordInvalid do
      Cashbox.create! :ip => "42.42.42.42", :port => 23, :name => "Dummy Cashbox 23"
    end
  end
end

class AddSpecialGuestIdOnTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :special_guest_id, :integer
  end

  def self.down
    remove_column :transactions, :special_guest_id
  end
end

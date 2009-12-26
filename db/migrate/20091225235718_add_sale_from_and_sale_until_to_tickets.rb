class AddSaleFromAndSaleUntilToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :available_from,   :datetime
    add_column :tickets, :available_until,  :datetime
  end

  def self.down
    remove_column :tickets, :available_from
    remove_column :tickets, :available_until
  end
end

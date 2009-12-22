class CreateTicketSales < ActiveRecord::Migration
  def self.up
    create_table :ticket_sales do |t|
      t.integer :transaction_id
      t.integer :ticket_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_sales
  end
end

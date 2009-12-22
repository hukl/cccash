class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :workshift_id
      t.boolean :canceled
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end

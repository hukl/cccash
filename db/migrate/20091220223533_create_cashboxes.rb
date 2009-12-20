class CreateCashboxes < ActiveRecord::Migration
  def self.up
    create_table :cashboxes do |t|
      t.string  :ip
      t.integer :port
      t.string  :name
      t.integer :printer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cashboxes
  end
end

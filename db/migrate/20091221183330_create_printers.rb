class CreatePrinters < ActiveRecord::Migration
  def self.up
    create_table :printers do |t|
      t.string :name
      t.string :cups_name

      t.timestamps
    end
  end

  def self.down
    drop_table :printers
  end
end

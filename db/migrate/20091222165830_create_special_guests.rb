class CreateSpecialGuests < ActiveRecord::Migration
  def self.up
    create_table :special_guests do |t|
      t.string :uid
      t.string :forename
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :special_guests
  end
end

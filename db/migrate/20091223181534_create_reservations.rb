class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :special_guest_id
      t.integer :ticket_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end

class CreateWorkshifts < ActiveRecord::Migration
  def self.up
    create_table :workshifts do |t|
      t.integer :user_id
      t.integer :money
      t.boolean :active
      t.datetime :activated_at
      t.datetime :deactivated_at
      t.boolean :cleared
      t.datetime :cleared_at
      t.boolean :balanced

      t.timestamps
    end
  end

  def self.down
    drop_table :workshifts
  end
end

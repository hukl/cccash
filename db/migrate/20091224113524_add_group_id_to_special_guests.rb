class AddGroupIdToSpecialGuests < ActiveRecord::Migration
  def self.up
    add_column :special_guests, :group_id, :integer
  end

  def self.down
    remove_column :special_guests, :group_id
  end
end

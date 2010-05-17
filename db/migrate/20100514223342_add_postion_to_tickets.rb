class AddPostionToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :position, :integer
  end

  def self.down
    remove_column :tickets, :position
  end
end

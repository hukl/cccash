class AddTaintedToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :tainted, :boolean
  end

  def self.down
    remove_column :users, :tainted
  end
end

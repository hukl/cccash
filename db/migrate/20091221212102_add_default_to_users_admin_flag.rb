class AddDefaultToUsersAdminFlag < ActiveRecord::Migration
  def self.up
    change_column :users, :admin, :boolean, :default => 'f'
  end

  def self.down
  end
end

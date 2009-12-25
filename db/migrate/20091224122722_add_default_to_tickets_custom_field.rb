class AddDefaultToTicketsCustomField < ActiveRecord::Migration
  def self.up
    change_column :tickets, :custom, :boolean, :default => 'f'
  end

  def self.down
  end
end

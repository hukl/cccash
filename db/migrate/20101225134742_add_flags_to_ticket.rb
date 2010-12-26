class AddFlagsToTicket < ActiveRecord::Migration
  def self.up
    add_column  :tickets, :upgrade, :boolean
    add_column  :tickets, :presale, :boolean
  end

  def self.down
    remove_column :tickets, :upgrade, :boolean
    remove_column :tickets, :presale, :boolean
  end
end
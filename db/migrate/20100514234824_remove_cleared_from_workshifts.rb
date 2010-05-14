class RemoveClearedFromWorkshifts < ActiveRecord::Migration
  def self.up
    remove_column :workshifts, :cleared
  end

  def self.down
    add_column :workshifts, :cleared, :boolean
  end
end

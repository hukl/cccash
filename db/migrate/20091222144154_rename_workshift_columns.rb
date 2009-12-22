class RenameWorkshiftColumns < ActiveRecord::Migration
  def self.up
    rename_column :workshifts, :activated_at, :started_at
    rename_column :workshifts, :deactivated_at, :ended_at
  end

  def self.down
    rename_column :workshifts, :started_at, :activated_at
    rename_column :workshifts, :ended_at, :deactivated_at
  end
end

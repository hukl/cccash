class AddClearedByToWorkshifts < ActiveRecord::Migration
  def self.up
		add_column :workshifts, :cleared_by_id, :integer
  end

  def self.down
		remove_column :workshifts, :cleared_by_id
  end
end

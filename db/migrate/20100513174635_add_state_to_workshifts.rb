class AddStateToWorkshifts < ActiveRecord::Migration
  def self.up
    add_column :workshifts, :state, :string
  end

  def self.down

    remove_column :workshifts, :state
  end
end

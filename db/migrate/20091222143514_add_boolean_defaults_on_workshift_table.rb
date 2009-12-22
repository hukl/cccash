class AddBooleanDefaultsOnWorkshiftTable < ActiveRecord::Migration
  def self.up
    change_column :workshifts, :cleared, :boolean, :default => 'f'
    change_column :workshifts, :active, :boolean, :default => 'f'
  end

  def self.down
  end
end

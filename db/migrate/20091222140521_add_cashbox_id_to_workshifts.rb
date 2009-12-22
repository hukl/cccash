class AddCashboxIdToWorkshifts < ActiveRecord::Migration
  def self.up
    add_column :workshifts, :cashbox_id, :integer
  end

  def self.down
    remove_column :workshifts, :cashbox_id
  end
end

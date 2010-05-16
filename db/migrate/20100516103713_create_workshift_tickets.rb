class CreateWorkshiftTickets < ActiveRecord::Migration
  def self.up
    create_table :workshift_tickets do |t|
      t.integer :workshift_id
      t.integer :ticket_id
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :workshift_tickets
  end
end

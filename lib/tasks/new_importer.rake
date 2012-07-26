require 'csv'

namespace :presale do
  desc "Import Ticket types from Presale"
  task :import_ticket_types => :environment do
      CSV::Reader.parse(File.open(File.join(Rails.root, "db", "ticket_types.csv")), ",") do |row|
        print row
        ticket = Ticket.create! :id => row[0], :name => row[1], :price => row[2], :presale => true
      end
  end
  
  desc "Import order tickets from Presale"
  task :import_order_tickets => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "ticket_codes.csv")), ",") do |row|
      group = Group.find_by_name("Presale") || Group.create(:name => "Presale")
      ticket = Ticket.find(row[2])

      next if SpecialGuest.find_by_uid(row[1])
      
      special_guest = SpecialGuest.create!  :name => row[0],
                                            :uid => row[1],
                                            :group_id => group.id
      
      reservation = Reservation.create!   :ticket_id => ticket.id,
                                          :special_guest_id => special_guest.id
    end
  end
  
  desc "Import member data"
  task :import_members => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "members.csv")), ",") do |row|
      group = Group.find_by_name("CCC") || Group.create(:name => "CCC")
      ticket = Ticket.find(2)
      
      print row.to_s + "\n"
      
      special_guest = SpecialGuest.create!  :name => row[0],
                                            :uid  => row[1],
                                            :group_id => group.id
                                            
      reservation = Reservation.create!     :ticket_id => ticket.id,
                                            :special_guest_id => special_guest.id
    end
  end
  
  desc "Import friends data"
  task :import_friends => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "friends.csv")), ",") do |row|
      group = Group.find_by_name("Friends") || Group.create(:name => "Friends")
      ticket = Ticket.find(1)
      
      print row.to_s + "\n"
      
      special_guest = SpecialGuest.create!  :name => row[0],
                                            :uid  => row[1],
                                            :group_id => group.id
                                            
      reservation = Reservation.create!     :ticket_id => ticket.id,
                                            :special_guest_id => special_guest.id      
    end
  end
end

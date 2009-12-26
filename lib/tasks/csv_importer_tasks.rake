require 'csv'

namespace :cccash do
  
  desc "Import CCC Member"
  task :import_ccc_member => :environment do
    SpecialGuest.delete_all
    
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "ccc.csv")), ";") do |row|
      group = Group.find_by_name("CCC") || Group.create(:name => "CCC")
      ticket_full     = Ticket.find_by_name("standard - ccc-member") ||                   create_custom_ticket("standard - ccc-member", 50, true)
      ticket_day1     = Ticket.find_by_name("day 1: ccc-member") ||                       create_custom_ticket("day 1: ccc-member", 20, true)
      ticket_day2     = Ticket.find_by_name("day 2: ccc-member") ||                       create_custom_ticket("day 2: ccc-member", 20, true)
      ticket_day3     = Ticket.find_by_name("day 3: ccc-member") ||                       create_custom_ticket("day 3: ccc-member", 20, true)
      ticket_day4     = Ticket.find_by_name("day 4: ccc-member") ||                       create_custom_ticket("day 4: ccc-member", 20, true)
      ticket_upgrade  = Ticket.find_by_name("upgrade-ticket: ccc-member -> standard") ||  create_custom_ticket("upgrade-ticket: ccc-member -> standard", 30, true)
      
      special_guest = SpecialGuest.create( :name => row[0], :uid => row[1], :group_id => group.id )
      special_guest.tickets << ticket_full
      special_guest.tickets << ticket_day1
      special_guest.tickets << ticket_day2
      special_guest.tickets << ticket_day3
      special_guest.tickets << ticket_day4
      special_guest.tickets << ticket_upgrade
      puts special_guest.name
    end
  end
  
  
  def create_custom_ticket name, price, custom
    Ticket.create! :name => name, :price => price, :custom => custom
  end
  
end
require 'csv'

namespace :cccash do
  
  desc "Import CCC Member"
  task :import_ccc_member => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "ccc.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
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
  end
  
  desc "Import CCCB Member"
  task :import_cccb_member => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "cccb.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
        group = Group.find_by_name("CCC") || Group.create(:name => "CCC")
        ticket_full     = Ticket.find_by_name("standard - ccc-member") ||                   create_custom_ticket("standard - ccc-member", 50, true)
        ticket_day1     = Ticket.find_by_name("day 1: ccc-member") ||                       create_custom_ticket("day 1: ccc-member", 20, true)
        ticket_day2     = Ticket.find_by_name("day 2: ccc-member") ||                       create_custom_ticket("day 2: ccc-member", 20, true)
        ticket_day3     = Ticket.find_by_name("day 3: ccc-member") ||                       create_custom_ticket("day 3: ccc-member", 20, true)
        ticket_day4     = Ticket.find_by_name("day 4: ccc-member") ||                       create_custom_ticket("day 4: ccc-member", 20, true)
        ticket_upgrade  = Ticket.find_by_name("upgrade-ticket: ccc-member -> standard") ||  create_custom_ticket("upgrade-ticket: ccc-member -> standard", 30, true)
        
        special_guest = SpecialGuest.create( :name => row[0], :group_id => group.id )
        special_guest.tickets << ticket_full
        special_guest.tickets << ticket_day1
        special_guest.tickets << ticket_day2
        special_guest.tickets << ticket_day3
        special_guest.tickets << ticket_day4
        special_guest.tickets << ticket_upgrade
        puts special_guest.name
      end
    end
  end
  
  desc "Import Sponsors"
  task :import_sponsors => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "sponsors.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
        group = Group.find_by_name("Sponsors") || Group.create(:name => "Sponsors")
        ticket_full = Ticket.find(:first, :conditions => {:name => "standard", :price => 0, :custom => true}) || create_custom_ticket("standard", 0, true)
        
        special_guest = SpecialGuest.create( :name => row[0], :group_id => group.id )
        special_guest.tickets << ticket_full
        puts special_guest.name
      end
    end
  end
  
  desc "Import our friends"
  task :import_friends => :environment do 
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "friends.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
        group = Group.find_by_name("Friends") || Group.create(:name => "Friends")
        ticket_full = Ticket.find(:first, :conditions => {:name => "standard", :price => row[2], :custom => true}) || create_custom_ticket("standard", row[2], true)
        
        special_guest = SpecialGuest.create( :name => row[0], :uid => row[1], :group_id => group.id )
        special_guest.tickets << ticket_full
        puts "Name: #{special_guest.name} Price #{special_guest.tickets.first.price}"
      end
    end
  end
  
  desc "Import our honor members"
  task :import_honor_members => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "honor_members.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
        group = Group.find_by_name("Honor") || Group.create(:name => "Honor")
        ticket_full = Ticket.find(:first, :conditions => {:name => "standard", :price => 0, :custom => true}) || create_custom_ticket("standard", 0, true)
        
        special_guest = SpecialGuest.create( :name => row[0], :group_id => group.id )
        special_guest.tickets << ticket_full
        puts "Name: #{special_guest.name} Price #{special_guest.tickets.first.price}"
      end
    end
  end
  
  desc "Import speakers"
  task :import_speakers => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "speakers.csv")), ";") do |row|
      unless SpecialGuest.find_by_name(row[0])
        group = Group.find_by_name("Speaker") || Group.create(:name => "Speaker")
        ticket_full = Ticket.find(:first, :conditions => {:name => "standard", :price => 0, :custom => true}) || create_custom_ticket("standard", 0, true)
        
        special_guest = SpecialGuest.create( :name => row[0], :group_id => group.id )
        special_guest.tickets << ticket_full
        puts "Name: #{special_guest.name} Price #{special_guest.tickets.first.price}"
      end
    end
  end
  
  desc "Import Presale tickets"
  task :import_presale_tickets => :environment do
    CSV::Reader.parse(File.open(File.join(Rails.root, "db", "presale.csv")), ";") do |row|
      group = Group.find_by_name("Presale") || Group.create(:name => "Presale")
      ticket_full = Ticket.find(:first, :conditions => {:name => translate_ticket(row[0]), :price => 0, :custom => true}) || create_custom_ticket(translate_ticket(row[0]), 0, true)
      special_guest = SpecialGuest.create( :uid => row[1], :group_id => group.id )
      special_guest.tickets << ticket_full
      puts "Name: #{special_guest.uid} Price #{special_guest.tickets.first.price}"
    end
  end
  
  def create_custom_ticket name, price, custom
    Ticket.create! :name => name, :price => price, :custom => custom
  end
  
  def translate_ticket name
    return "standard" if "Standard"
    return "standard - ccc-member" if "Member"
    return "supporter" if "Supporter"
    return "business" if "Business"
    return "standard-pupil" if "Pupil"
  end
end
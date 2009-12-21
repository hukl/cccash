namespace :cccash do
  
  desc "Create Dummy Admin and Angel User"
  task :create_dummy_users => :environment do
    User.create!(
      :login                  => "admin",
      :name                   => "Dummy Admin",
      :password               => "foobar",
      :password_confirmation  => "foobar",
      :admin                  => true
    )
    puts "Admin User Created"
    
    User.create!(
      :login                  => "angel",
      :name                   => "Dummy Angel",
      :password               => "foobar",
      :password_confirmation  => "foobar"
    )
    puts "Angel User Created"
  end
end
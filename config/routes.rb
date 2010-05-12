ActionController::Routing::Routes.draw do |map|
  
  map.root      :controller => :sessions, :action => :new
  
  
  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'
  map.admin     '/admin',     :controller => :admin, :action => :index
  
  map.resources :users
  map.resource  :session
  map.resource  :cart, :member => {
    :add_ticket_to      => :put,
    :remove_ticket_from => :delete,
    :checkout           => :get,
    :wait_for_cashbox   => :post,
    :cancel_most_recent => :get,
    :confirm_cancel     => :post
  }
  map.resources :cashboxes
  map.resources :groups
  map.resources :printers
  map.resources :tickets
  map.resources :workshifts, :member     => { 
    :toggle_activation  => :put,
    :clear              => :post,
    :billing            => :get
  }
  
  map.resources :special_guests,  :collection => { :search => :get }
  map.resources :transactions

  if Rails.env != 'production'
    map.with_options :controller => 'mock_cashbox' do |mock|
      %w(open status wait_for_close print).each do |command|
        mock.mock_cashbox command, :action => command
      end
    end
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Routes.draw do |map|
  
  map.root      :controller => :sessions, :action => :new
  
  
  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'
  
  map.resources :users
  map.resource  :session
  map.resource  :cart, :member => {
    :add_ticket_to      => :put,
    :remove_ticket_from => :delete
  }
  map.resources :cashboxes
  map.resources :groups
  map.resources :printers
  map.resources :tickets
  map.resources :workshifts

  map.admin   '/admin', :controller => :admin, :action => :index
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

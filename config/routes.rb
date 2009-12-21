ActionController::Routing::Routes.draw do |map|
  map.resources :cashboxes
  map.resources :groups
  map.admin   '/admin', :controller => :admin, :action => :index
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

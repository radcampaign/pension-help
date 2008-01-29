ActionController::Routing::Routes.draw do |map|
  map.resources :partners

  map.resources :restrictions

  map.resources :agencies do |agency|
    agency.resources :locations
    agency.resources :plans
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
    
  # Site URLs
  map.with_options(:controller => 'site') do |site|
    site.homepage          '',              :action => 'show_page', :url => '/'
    site.not_found         'site/404',     :action => 'not_found'
    site.error             'site/500',     :action => 'error'

    # Everything else
    site.connect           '*url',          :action => 'show_page'
  end
end

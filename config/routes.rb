Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    get "account/login", :to => "devise/sessions#new"
    delete "users/sign_out", :to => 'devise/sessions#destroy'
    post "users/sign_in", :to => 'session#create'
  end

  root 'site#show_page', :url => '/'

  namespace :admin do
    resources :content do
      collection do
        get :list
      end
    end
    resources :images, only: [:index]
    resources :menu, only: [:index]
    resources :site do
      collection do
        get :show_page
      end
    end
    resources :feedback do
      collection do
        get :show_form
      end
    end
  end

  resources :agencies do
    resources :locations do
      collection do
        get :get_cities_for_counties
        get :get_zips_for_counties
        get :get_counties_for_states
      end
    end
    resources :plans do
      collection do
        get :get_cities_for_counties
        get :get_zips_for_counties
        get :get_counties_for_states
      end
    end
    collection do
      get :go_to_agencies
      get :get_cities_for_counties
      get :get_zips_for_counties
      get :get_counties_for_states
      get :switch_counseling
      get :switch_active
      get :sort_plan
      post :ajax_search
      post :sort_plan
    end
  end

  resources :state do
    collection do
      get :catchall_employees
      post :sort_catchall_employee
    end
  end

  resources :publications

  resources :partners, only: [:index, :show, :edit, :destroy]

  resources :feedback do
    collection do
      post :save_feedback
    end
  end

  resources :feedbacks, only: [:index, :show, :update, :edit, :delete], :controller => :feedback do
    collection do
      get :show_form
    end
  end

  resources :help do
    collection do
      get :counseling
      get :resources
      get :step_3
      get :step_5
      get :results
      get :last_step
      post :step_2
      post :email
      post :check_aoa_zip
      post :process_last_step
    end
  end

  resources :works, only: [:index, :create] do
    collection do
      get :pal
      get :npln
      get :questions
    end
  end

  match "/500", :to => "site#internal_error", via: [:get]

  get '*url', to: 'site#show_page'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

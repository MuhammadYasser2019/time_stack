Rails.application.routes.draw do
  resources :holiday_exceptions
  resources :time_entries
  resources :weeks
  resources :tasks
  resources :projects
  resources :customers
  resources :roles
  resources :users
  resources :holidays
  resources :customers_holidays
  devise_for :users, :path => "account", :controllers => { registrations: 'registrations', invitations: 'invitations', :omniauth_callbacks => "users/omniauth_callbacks" }
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    match "/users/sign_in", :to => 'devise/sessions#new', via: [:get, :post]
    match "/users/sign_out", :to => 'devise/sessions#destroy', via: [:delete]
    match '/invitation/resend_invite' => 'invitations#resend_invite', via: [:post]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  post '/weeks/:id(.:format)' => 'weeks#update'
  # You can have the root of your site routed with "root"
  root 'weeks#index'
  get 'weeks/:id/report' => 'weeks#report'

  get 'projects/approve/:week_id/:row_id' => 'projects#approve'
  get 'projects/reject/:id' => 'projects#reject'
  get 'show_project_reports' => 'projects#show_project_reports'
  post 'projects/:id/deactivate_project' => 'projects#deactivate_project'
  post 'projects/:id/reactivate_project' => 'projects#reactivate_project'
  post 'time_reject' => 'weeks#time_reject'
  post 'show_hours' => 'projects#show_hours'

  get 'add_user_to_project' => "projects#add_user_to_project"
  get '/projects/:id/user_time_report' => 'projects#user_time_report'
  match 'user_account', :to => "users#user_account",  via: [:get, :post]
  match 'admin', :to => "users#admin", via: [:get, :post]
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'available_tasks/:id' => 'tasks#available_tasks'
  
  get 'check_holidays/:id' => "holidays#check_holidays"

  post 'customers/report' => 'customers#report'
  
  get 'permission_denied' => 'projects#permission_denied'

  get "/users/:id/proxies/" => "users#proxies"
  
  get "/users/:id/proxies/:proxy_id" => "users#proxy_users"
  
  get "/users/:user_id/proxies/:proxy_id/proxy_users/:proxy_user" => "weeks#proxy_week"
  
  post "/users/invite_customer" => "users#invite_customer"
  
  post "/customers/invite_to_project" => "customers#invite_to_project"
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

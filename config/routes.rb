Rails.application.routes.draw do

  resources :archived_time_entries, only: [:index, :show, :create]
  resources :archived_weeks, only: [:index, :show, :create]
  resources :holiday_exceptions
  resources :time_entries
  resources :weeks 
  resources :tasks
  resources :projects
  resources :customers
  resources :roles
  resources :users
  resources :holidays
  resources :employment_types
  resources :customers_holidays
  resources :report_logos
  resources :features
  resources :case_studies
  resources :vacation_types
  resources :analytics
  devise_for :users, :path => "account", :controllers => { passwords: 'passwords', registrations: 'registrations', invitations: 'invitations', :omniauth_callbacks => "users/omniauth_callbacks" }
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
  authenticated :user do
    root to: 'weeks#index', as: :authenticated_root
  end
  #root 'weeks#index'
  root 'static_pages#home'

  post 'change_status' => 'weeks#change_status', as: :change_status
  get 'duplicate' => 'weeks#duplicate'
  get 'weeks/:id/report' => 'weeks#report'
  
  get '/dynamic_project_update' => 'projects#dynamic_project_update'
  get '/dynamic_customer_update' => 'customers#dynamic_customer_update'

  get 'projects/:id/approve/:week_id/:row_id' => 'projects#approve'
  get 'projects/:id/reject/:week_id' => 'projects#reject'
  get 'show_project_reports' => 'projects#show_project_reports'
  post 'add_multiple_users_to_project' => "projects#add_multiple_users_to_project"
  post 'remove_multiple_users_from_project' => "projects#remove_multiple_users_from_project"
  post 'show_project_reports' => 'projects#show_project_reports'
  post 'projects/:id/deactivate_project' => 'projects#deactivate_project'
  post 'projects/:id/reactivate_project' => 'projects#reactivate_project'
  post 'time_reject' => 'weeks#time_reject'
  post 'show_hours' => 'projects#show_hours'
  post '/pending_email' => 'projects#pending_email'
  post '/customers_pending_email' => 'customers#customers_pending_email'
  post '/previous_comments' => 'weeks#previous_comments'
  post '/shared_user' => 'customers#shared_user'
  get '/add_shared_users' => 'customers#add_shared_users'

  get '/show_user_reports/:id' => 'users#show_user_reports'
  post '/show_user_reports/:id' => 'users#show_user_reports'

  get '/set_default_project' => 'users#set_default_project'
  
  get 'add_user_to_project' => "projects#add_user_to_project"
  get '/projects/:id/user_time_report' => 'projects#user_time_report'
  match 'user_account', :to => "users#user_account",  via: [:get, :post]
  match 'admin', :to => "users#admin", via: [:get, :post]
  post 'update_front_page_content' => "features#update_front_page_content"
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'remove_user_from_customer' => "customers#remove_user_from_customer"
  get 'shared_user' => "customers#shared_user"
  get 'add_pm_role' => "customers#add_pm_role"
  get 'assign_proxy_role' => "customers#assign_proxy_role"
  get 'edit_customer_user/:user_id' => "customers#edit_customer_user"
  get '/update_user_employment' => "customers#update_user_employment"
  get 'vacation_request' => "customers#vacation_request"
  get 'customers/approve_vacation/:vr_id/:row_id' => 'customers#approve_vacation'
  get 'customers/reject_vacation/:vr_id/:row_id' => 'customers#reject_vacation'
  get 'resend_vacation_request' => 'customers#resend_vacation_request'
  get 'customers/:id/theme' => 'customers#set_theme'
  # Form to reset status_id and duplicate exist
  get '/reset_timesheet/:customer_id' => 'users#reset'
  post '/reset_timesheet/:customer_id' => 'users#reset'
  get 'approved_week' => 'users#approved_week'
  post 'approved_week' => 'users#approved_week'
  get 'default_week' => 'users#default_week'

  #Questionaite
  post 'customers/questionaire' => 'customers#questionaire'
  get 'assign_report_logo_to_user' => "users#assign_report_logo_to_user"

  get 'user_profile' => "users#user_profile"
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'available_tasks/:id' => 'tasks#available_tasks'
  get 'available_data/:id' => 'features#available_data'
  get 'available_users/:id' => 'customers#available_users'
  get '/default_comment' => 'tasks#default_comment'
  
  get 'check_holidays/:id' => "holidays#check_holidays"

  get 'customer_reports/:id' => 'customers#customer_reports'
  get 'customers/:id/customer_reports' => 'customers#customer_reports'
  
  get 'permission_denied' => 'projects#permission_denied'

  get "/users/:id/proxies/" => "users#proxies"
  
  get "/users/:id/proxies/:proxy_id" => "users#proxy_users"
  get "/users/:id/proxies/:proxy_id/enter_timesheets" => "users#enter_timesheets"
  get "/users/:id/proxies/:proxy_id/show_timesheet_dates" => "users#show_timesheet_dates"
  post "/users/:id/proxies/:proxy_id/fill_timesheet" => "users#fill_timesheet"
  get "/users/:id/proxies/:proxy_id/add_proxy_row" => "users#add_proxy_row", as: :add_proxy_row
  
  get "/users/:user_id/proxies/:proxy_id/proxy_users/:proxy_user" => "weeks#proxy_week"
  
  post "/users/invite_customer" => "users#invite_customer"
  
  post "/customers/invite_to_project" => "customers#invite_to_project"
  post "project/:project_id/add_adhoc_pm" => "projects#add_adhoc_pm", as: :add_adhoc_pm
  post "customer/:customer_id/add_adhoc_pm_by_cm" => "customers#add_adhoc_pm_by_cm", as: :add_adhoc_pm_by_cm
  get "/copy_timesheet/:id" => "weeks#copy_timesheet"
  get "/show_all_projects" => "projects#show_all_projects"
  post "assign_employment_types/" => "customers#assign_employment_types", as: :assign_employment_types
  post "assign_pm/:id" => "customers#assign_pm", as: :assign_pm
  get "/clear_timesheet/:id" => "weeks#clear_timesheet"
  get "/show_old_timesheets" => "projects#show_old_timesheets"
  post "/add_previous_comments" => "weeks#add_previous_comments", as: :add_previous_comments
  get 'remove_emp_from_vacation' => "customers#remove_emp_from_vacation"
  match "/expense_records" => 'weeks#expense_records', via: [:get, :post]
  get '/delete_expense' => "weeks#delete_expense"
  post "/add_expense_records" => "weeks#add_expense_records"
  get 'get_employment/' => 'customers#get_employment'

  get "vacation_reports/customer/:id" => 'analytics#vacation_report'
  get "user_activities/:id" => 'analytics#user_activities'
  match "customers/:id/analytics" => 'analytics#customer_reports', via: [:get, :post] 
  post "/bar_graph" => 'analytics#bar_graph'
  mount Ckeditor::Engine => '/ckeditor'


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

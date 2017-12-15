# set :application, "time_stack"
# set :repo_url, "git@github.com:sameersharma25/time_stack.git"

set :user, 'ssharma'
set :scm, :git
# set :branch, "master"

puts "  *************************************************************"
puts "  *** Deploying to DEVELOPMENT with username #{fetch(:user)} ***"
puts "  *************************************************************"
set :rails_env, 'development'
set :repository,"git@github.com:sameersharma25/time_stack.git"
set :branch, "master"
set :use_sudo, false
set :deploy_to, "/home/ssharma/dev/timestack_releases"
puts "  ******Deploying to #{fetch(:deploy_to)}"
set :keep_releases, 5

# set :domain, '192.168.239.222'
role :web, 'ssharma@184.178.49.37'                          # Your HTTP server, Apache/etc
role :app, 'ssharma@184.178.49.37'                          # This may be the same as your `Web` server
role :db,  'ssharma@184.178.49.37', :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# default_run_options[:pty] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
  	on roles(:app), :except => { :no_release => true } do
    	run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  	end
  end
end

# # Define roles, user and IP address of deployment server
# # role :name, %{[user]@[IP adde.]}
# role :app, %w{ssharma@184.178.49.37}
# role :web, %w{ssharma@184.178.49.37}
# role :db,  %w{ssharma@184.178.49.37}
#
# # Define server(s)
# server '184.178.49.37', user: 'ssharma', roles: %w{web}
#
# # SSH Options
# # See the example commented out section in the file
# # for more options.
# set :ssh_options, {
#     forward_agent: false,
#     auth_methods: %w(password),
#     password: 'ZAQ!2wsx',
#     user: 'ssharma',
# }
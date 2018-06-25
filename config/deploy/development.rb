require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

set :application, "time_stack"

# set :repo_url, "git@github.com:sameersharma25/time_stack.git"

set :user, 'susmitha'
#set :scm, :git
# set :branch, "master"

puts "  *************************************************************"
puts "  *** Deploying to DEVELOPMENT with username #{fetch(:user)} ***"
puts "  *************************************************************"
set :rails_env, 'development'
set :repo_url,"git@github.com:sameersharma25/time_stack.git"
set :branch, "master"
#set :use_sudo, true
set :deploy_to, "/c/Users/susmitha/capistrano_test"
puts "  ******Deploying to #{fetch(:deploy_to)}"
set :keep_releases, 5

# set :domain, '192.168.239.222'
role :web, '192.168.1.239'                          # Your HTTP server, Apache/etc
role :app, '192.168.1.239'                       # This may be the same as your `Web` server
role :db,  '192.168.1.239', :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
#server '192.168.1.239', user: 'susmitha', roles: %w{web app db}, password: '9542811137'

# default_run_options[:pty] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
  	on roles(:app), :except => { :no_release => true } do
  		puts "RESTART"
    	#run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    	execute :touch, current_path.join('tmp/restart.txt')
  	end
  end
end
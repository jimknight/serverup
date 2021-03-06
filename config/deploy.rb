require "bundler/capistrano"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
load 'deploy/assets'

set   :domain,        "198.211.96.39"
role  :web,           domain
role  :app,           domain
role  :db,            domain, :primary => true

# Fill user in - if remote user is different to your local user
set :user, "deployer"

default_run_options[:pty] = true

set :application, "serverup"
set :scm, :git
set :repository,  "."
set :deploy_via, :copy
set :deploy_to, "/home/#{user}/apps/#{application}"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :upload_settings, :roles => :app do
    top.upload("config/application.yml", "#{release_path}/config/application.yml", :via => :scp)
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code', 'deploy:upload_settings'
set :application, "hallist"
set :deploy_to, '/home/ubuntu/app'


require "bundler/capistrano"
# require 'capistrano-unicorn'

_cset(:app_env)        { (fetch(:rails_env) rescue 'production') }

set :use_sudo, false
set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "git@github.com:jparbros/arto.git"
set :branch, "master"
set :bundle_cmd, "/home/ubuntu/.rbenv/shims/bundle"

set :user, "ubuntu"
# set :password, 'Passw0rd'
# role :web, "64.49.246.62"                          # Your HTTP server, Apache/etc
# role :app, "64.49.246.62"                          # This may be the same as your `Web` server
role :web, "107.21.235.97"                          # Your HTTP server, Apache/etc
role :app, "107.21.235.97"                          # This may be the same as your `Web` server
ssh_options[:keys] = 'config/hallist.pem'

default_run_options[:pty] = true

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
set :normalize_asset_timestamps, false



namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f /home/ubuntu/app/shared/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :precompile, :role => :app do
    run "cd #{release_path}/ && bundle exec rake assets:precompile"
  end
end

namespace :unicorn do
  desc "Stop Unicorns"
  task :stop, :role => :app do
    run "cd #{deploy_to}/current/ && kill -s TERM `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end
  
  desc "Start Unicorns"
  task :start, :role => :app do
    run "cd #{deploy_to}/current/ && bundle exec unicorn -c #{deploy_to}/current/config/unicorn/#{app_env}.rb -E #{app_env} -D"
  end
  
  desc "Restart Unicorns"
  task :restart, :role => :app do
    run <<-END
      cd #{release_path}/ && kill -s TERM `cat #{release_path}/tmp/pids/unicorn.pid`;
      sleep 2;
      cd #{release_path}/ && bundle exec unicorn -c #{release_path}/config/unicorn/#{app_env}.rb -E #{app_env} -D;
    END
  end
end

after 'deploy:restart', 'unicorn:restart'
# after 'deploy:restart', 'unicorn:reload'
after "deploy:finalize_update", "db:db_config"
after "deploy:finalize_update", "deploy:precompile"
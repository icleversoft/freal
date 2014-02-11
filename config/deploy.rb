require "bundler/capistrano"
require "whenever/capistrano"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")#'ruby-1.9.3-p484@freal'
# Add RVM's lib directory to the load path.
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"


# set :rvm_type, :user  # Don't use system-wide RVM
set :port,            2223
set :scm,             :git
set :repository,      "git@github.com:icleversoft/freal.git"
# set :repository,      "http://github.com/icleversoft/freal.git"
set :branch,          "master"
set :scm_passphrase,  "m@rio666"
set :scm_username,    "iphone@icleversoft.com"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }
# set :git_shallow_clone, 1
set :scm_verbose, true

set :keep_releases,   2

set :rails_env,       "development"
set :whenever_environment, defer { "#{rails_env}" }
set :whenever_identifier, defer { "#{application}_#{rails_env}" }
set :deploy_to,       "/home/gstavrou/apps/freal"
# set :deploy_via,      :export
# set :deploy_via,      :remote_cache

set :normalize_asset_timestamps, false

set :user,            "gstavrou"
set :group,           "gstavrou"
set :use_sudo,         false

role :web, "83.212.110.231"                          # Your HTTP server, Apache/etc
role :app, "83.212.110.231"                          # This may be the same as your `Web` server
role :db,  "83.212.110.231", :primary => true        # This is where Rails migrations will run

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:releases_path)   { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

default_run_options[:pty]   = true

default_environment["RAILS_ENV"] = 'development'

# Use our ruby-1.9.3-p374@web-template gemset
default_environment["PATH"]         = "/home/gstavrou/.rvm/gems/ruby-1.9.3-p484@freal/bin:/home/gstavrou/.rvm/rubies/ruby-1.9.3-p484/bin:/home/gstavrou/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
default_environment["GEM_HOME"]     = "/home/gstavrou/.rvm/gems/ruby-1.9.3-p484@freal"
default_environment["GEM_PATH"]     = "/home/gstavrou/.rvm/gems/ruby-1.9.3-p484@freal" "/home/gstavrou/.rvm/gems/ruby-1.9.3-p484@freal"
default_environment["RUBY_VERSION"] = "ruby-1.9.3-p484@freal"

default_run_options[:shell] = 'bash'

namespace :deploy do
  desc "Deploy your application"
  task :default do
    update
    restart
  end

  # desc "expand the gems"
  # task :gems, :roles => :web, :except => { :no_release => true } do
  #   run "cd #{current_path}; #{shared_path}/bin/bundle unlock"
  #   run "cd #{current_path}; nice -19 #{shared_path}/bin/bundle install vendor/" # nice -19 is very important otherwise DH will kill the process!
  #   run "cd #{current_path}; #{shared_path}/bin/bundle lock"
  # end
  # 
  desc "Setup your git-based deployment app"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone -b #{branch} #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    # run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    run "cd #{current_path}; git pull origin #{branch}"
    run "cd #{current_path}; bundle install"
    # run "cd #{current_path}; bundle install --no-deployment"
# if [ -d data/shared/cached-copy ];
# then cd data/shared/cached-copy && git remote set-url origin git@git:project.git && git fetch -q origin && git reset -q --hard 5da89014b1fdb96a46fdafa08d05a1e841c3c011 && git clean -q -d -x -f;
# else git clone -q git@git:project.git data/shared/cached-copy && cd data/shared/cached-copy && git checkout -q -b deploy 5da89014b1fdb96a46fdafa08d05a1e841c3c011;
# fi    
    finalize_update
    restart
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    #----------------W A R N I N G----------------
    #If the line below is added in the command list below, the unicorn DOES NOT START!
    #ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
    #----------------W A R N I N G----------------
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -sf #{shared_path}/public/system #{latest_release}/public/system &&
      ln -sf #{shared_path}/mongoid.yml #{latest_release}/config/mongoid.yml
    CMD
    
    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end

  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    if remote_file_exists?("#{latest_release}/tmp/pids/unicorn.pid")
      run "kill -s USR2 `cat #{latest_release}/tmp/pids/unicorn.pid`"
    end
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    if remote_file_exists?("#{latest_release}/tmp/pids/unicorn.pid")
      run "kill -s QUIT `cat #{latest_release}/tmp/pids/unicorn.pid`"
    end
  end

  # desc "Start APN Broadcaster"
  # task :apn_start, :except => { :no_release => true } do
  #   run "cd #{current_path} ; ./apnserver"
  # end
  # 
  # desc "Stop APN Broadcaster"
  # task :apn_stop, :except => { :no_release => true } do
  #   if remote_file_exists?("#{latest_release}/apnmachined.pid")
  #     run "kill -s QUIT `cat #{latest_release}/apnmachined.pid`"
  #   end
  # end
  # 
  # desc "Stop WS"
  # task :ws_stop, :except => { :no_release => true } do
  #   run "cd #{current_path}/websocket ; ./stop_server"
  # end
  # 
  # desc "Start WS"
  # task :ws_start, :except => { :no_release => true } do
  #   run "cd #{current_path}/websocket ; ./start_server"
  # end

  namespace :mongo do
    desc "Create Indexes"
    task :create_indexes do
      run "cd #{current_path} ; bundle exec rake db:mongoid:create_indexes"
    end
    
    desc "Remove Indexes"
    task :remove_indexes do
      run "cd #{current_path} ; bundle exec rake db:mongoid:remove_indexes"
    end
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
  
  namespace :rvm do
    desc "RVM trust"
    task :trust_rvmrc do
      run "rvm rvmrc trust #{release_path}"
    end
    
    desc "Install bundler"
    task :bundler do
      run "cd #{current_path};gem install bundler"
      run "rvm wrapper `rvm current` bundle bundle"
    end
  
  end  
  
  
  
  namespace :assets do
    desc "Precompile assets"
    task :precompile, :roles => :web, :except => { :no_release => true }  do
      run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} assets:precompile"
    end

    desc "Cleanup assets"
    task :cleanup, :roles => :web, :except => { :no_release => true }  do
      run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} assets:clean"
    end
  end
end

#Both of two following commands in namespace ws are failed because
#websocket app runs in a different gemset (ws) than main's server one
#TODO:Move websocket app out of main app and install a clean
#capify file only for it
namespace :ws do
  desc "Start WebSocket Server"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path}/websocket; rake websocket_rails:start_server"
  end
  
  desc "Stop Websocket Server"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path}/websocket; rake websocket_rails:stop_server"
  end
end


after "deploy:setup", "deploy:rvm:trust_rvmrc", "deploy:rvm:bundler", "bundle:install", "deploy:assets:precompile"

after "deploy:restart", "deploy:apn_stop", "deploy:apn_start"

# Helper functions
def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
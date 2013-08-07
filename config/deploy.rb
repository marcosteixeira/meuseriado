set :application, "meuseriado"
set :user, "marcosteixeira"
set :group, "www-data"
set :repository, "git@github.com:marcosteixeira/meuseriado.git"
set :scm, "git"
set :deploy_to, "/home/marcosteixeira/meuseriado/"
default_run_options[:pty] = true
set :use_sudo, false
set :rails_env, :production
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server "192.241.234.24", :app, :web, :db, :primary => true
set :deploy_via, :copy
set :stages, ["production"]
set :default_stage, "production"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
    task :restart, :roles => :app, :except => { :no_release => true } do
        run "cd #{current_path} && touch tmp/restart.txt"
    end
end
after :deploy, 'deploy:database'
namespace :deploy do
    task :database, :roles => :app do
        run "cp #{deploy_to}shared/database.yml #{current_path}/config/"
    end
end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --deployment && rake db:migrate RAILS_ENV=\"production\""
  end

end
before "deploy:restart", "bundle:install"

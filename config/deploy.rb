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
set :stages, ["production"]
set :default_stage, "production"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && touch tmp/restart.txt"
  end
end
before :deploy, 'deploy:copia_imagens'
after :deploy, 'deploy:database'
namespace :deploy do
  task :database, :roles => :app do
    run "cp #{deploy_to}shared/database.yml #{current_path}/config/"
  end
  task :copia_imagens do
    run "mv #{current_path}/app/assets/images/series/ #{deploy_to}shared/"
  end

end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --deployment && rake db:migrate RAILS_ENV=\"production\""
  end
  task :restaura_imagens do
    run "cp -r  #{deploy_to}shared/series/ #{current_path}/app/assets/images/ && rm -rf #{deploy_to}shared/series/ "
  end
end
before "deploy:restart", "bundle:install"
after "bundle:install", "bundle:restaura_imagens"

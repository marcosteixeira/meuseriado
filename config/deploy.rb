set :application, "meuseriado"
set :user, "marcosteixeira"
set :scm, :subversion
set :scm_username, "m.viniteixeira@gmail.com"
set :scm_passphrase, "CX3Xa6qU6Uk5"
set :repository, "https://meuseriado.googlecode.com/svn/trunk/"
set :deploy_to, "/home/marcosteixeira/meuseriado/"
default_run_options[:pty] = true
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server "netseries.com.br", :app, :web, :db, :primary => true

set :stages, ["production"]
set :default_stage, "production"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
task :after_update_code, :roles => [:web, :db, :app] do
  run "chown www:data:www:data -R #{deploy_to}" 
end
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
        run "cp #{deploy_to}/shared/database.yml #{current_path}/config/"
    end
end
# If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#end
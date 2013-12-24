load 'deploy'
# Uncomment if you are using Rails' asset pipeline
# load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"



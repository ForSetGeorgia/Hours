##################################
##### SET THESE VARIABLES ########
##################################
server "alpha.forset.ge", :web, :app, :db, primary: true # server where app is located
set :application, "Hours" # unique name of application
set :user, "deploy"# name of user on server
set :ngnix_conf_file_loc, "production/nginx.conf" # location of nginx conf file
set :unicorn_init_file_loc, "production/unicorn_init.sh" # location of unicor init shell file
set :github_account_name, "ForSetGeorgia" # name of accout on git hub
set :github_repo_name, "Hours" # name of git hub repo
set :git_branch_name, "master" # name of branch to deploy
set :rails_env, "production" # name of environment: production, staging, ...
##################################

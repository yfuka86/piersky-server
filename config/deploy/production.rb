set :branch, 'master'

set :stage, :production
set :rails_env, :production
set :db_host, 'pierskyproduction.c9k2qzmecdkt.us-west-1.rds.amazonaws.com'

set :bundle_binstubs, nil
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/shared node_modules}

set :sidekiq_processes, 1

server '45.79.81.58', user: fetch(:user), roles: %w{app web}, primary: true
server '45.79.109.107', user: fetch(:user), roles: %w{app web cron worker}
# redis-server '192.155.83.40'

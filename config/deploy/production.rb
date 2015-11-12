set :branch, 'master'

set :stage, :production
set :rails_env, :production
set :db_host, 'localhost'

set :bundle_binstubs, nil
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/shared node_modules}

set :sidekiq_processes, 1

set :whenever_environment, :production

server '45.79.81.58', user: fetch(:user), roles: %w{web app db sidekiq}, primary: true

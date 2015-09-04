lock '3.4.0'

set :application, 'piersky'
set :repo_url, 'git@github.com:yfuka86/piersky.git'
set :user, "deploy"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/piersky/id_rsa')],
  forward_agent: true,
  port: 7213
}

set :linked_files, %w{config/database.yml}

namespace :deploy do
  desc "Start unicorn"
  task :start do
    on roles(:app) do
      execute "service unicorn_#{fetch(:application)} start"
    end
  end
  desc "Stop unicorn"
  task :stop do
    on roles(:app) do
      execute "service unicorn_#{fetch(:application)} stop"
    end
  end
  desc "Restart application"
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 6 do
      execute "service unicorn_#{fetch(:application)} restart"
    end
  end
end

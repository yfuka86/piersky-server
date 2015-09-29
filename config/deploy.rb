lock '3.4.0'

set :application, 'piersky'
set :repo_url, 'git@github.com:yfuka86/piersky.git'
set :user, "deploy"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :slack_webhook, "https://hooks.slack.com/services/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"

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/piersky/id_rsa')],
  forward_agent: true,
  port: 7231
}

set :linked_files, %w{config/database.yml}

set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :sidekiq_role, :sidekiq
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

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

%w[start stop restart].each do |command|
  desc "#{command} nginx"
  task command do
    on roles(:app) do
      execute :sudo, "service nginx #{command}"
    end
  end
end

desc "Update Unicorn configuration"
task :update do
  on roles(:app) do
    template "unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
  end
end

# https://www.digitalocean.com/community/tutorials/how-to-install-cassandra-and-run-a-single-node-cluster-on-a-ubuntu-vps
namespace :cassandra do
  desc "install java and Cassandra"
  task :install do
    on roles(:app) do
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} Cassandra"
    task command do
      on roles(:app) do
        execute :sudo, "/home/deploy/cassandra/tools/bin/cassandra-stressd #{command}"
      end
    end
  end

  desc "Setup Cassandra"
  task :setup do
    on roles(:app) do
      execute "RAILS_ENV=production bundle exec rake cequel:keyspace:create"
      execute "RAILS_ENV=production bundle exec rake cequel:migrate"
    end
  end
end

lock '3.4.0'

# When you run cap production deploy, it runs these tasks:

# deploy
#   deploy:starting
#     [before]
#       deploy:ensure_stage
#       deploy:set_shared_assets
#     deploy:check
#   deploy:started
#   deploy:updating
#     git:create_release
#     deploy:symlink:shared
#   deploy:updated
#     [before]
#       deploy:bundle (bundle install)
#       deploy:migrate (rake db:migrate)
#       deploy:compile_assets (rake assets:precompile)
#       deploy:normalize_assets
#     [after]
#   deploy:publishing
#     deploy:symlink:release
#   deploy:published
#   deploy:finishing
#     deploy:cleanup
#   deploy:finished
#     deploy:log_revision

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

set :gulp_file, -> { release_path.join('gulpfile.js') }
set :gulp_tasks, ['build-production']

set :whenever_environment, :production
set :whenever_command, "cd #{current_path}; crontab -r; RAILS_ENV=#{fetch(:whenever_environment)} bundle exec whenever --update-crontab"
set :whenever_roles, -> { :cron }

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

  desc "Update Unicorn configuration"
  task :update do
    on roles(:app) do
      template "unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
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

namespace :node do
  desc "Run npm install"
  task :install do
    on roles(:web) do
      within release_path do
        execute :sudo, "npm cache clean"
        execute :sudo, "npm install --production --no-spin"
      end
    end
  end

  task :update do
    on roles(:web) do
      execute :sudo, "npm update -g npm"
    end
  end
end

before "deploy:updated", "node:install"
before "deploy:updated", :gulp
after "deploy:publishing", "deploy:restart"

# https://www.digitalocean.com/community/tutorials/how-to-install-cassandra-and-run-a-single-node-cluster-on-a-ubuntu-vps
# namespace :cassandra do
#   desc "install java and Cassandra"
#   task :install do
#     on roles(:app) do
#     end
#   end

#   %w[start stop restart].each do |command|
#     desc "#{command} Cassandra"
#     task command do
#       on roles(:app) do
#         execute :sudo, "/home/deploy/cassandra/tools/bin/cassandra-stressd #{command}"
#       end
#     end
#   end

#   desc "Setup Cassandra"
#   task :create do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "cequel:keyspace:create"
#         end
#       end
#     end
#   end

#   task :setup do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "cequel:migrate"
#         end
#       end
#     end
#   end
# end

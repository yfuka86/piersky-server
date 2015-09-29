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
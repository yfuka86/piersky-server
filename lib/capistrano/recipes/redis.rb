namespace :redis do
  desc "Install latest stable release of nginx"
  task :install do
    on roles(:redis) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install redis-server"
    end
  end
  after "deploy:install", "redis:install"

  %w[start stop restart].each do |command|
    desc "#{command} redis-server"
    task command do
      on roles(:redis) do
        execute :sudo, "service redis-server #{command}"
      end
    end
  end
end

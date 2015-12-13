namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nodejs"
      execute :sudo, "ln -sf /usr/bin/nodejs /usr/bin/node"
      execute :sudo, "apt-get -y install npm"
    end
  end
  after "deploy:install", "nodejs:install"
end

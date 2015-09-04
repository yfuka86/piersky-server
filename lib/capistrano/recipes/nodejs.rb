namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nodejs"
    end
  end
  after "deploy:install", "nodejs:install"
end

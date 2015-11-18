namespace :phantomjs do
  desc "Install Phantomjs2.0"
  task :install do
    on roles(:app), only: {primary: true} do
      execute :sudo, "apt-get -y install phantomjs"
    end
  end
  after "deploy:install", "phantomjs:install"
end

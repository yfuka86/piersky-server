namespace :nginx do

  desc "Install latest stable release of nginx"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nginx"
    end
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup do 
    on roles(:app) do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      execute :sudo, "mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute :sudo, "rm -f /etc/nginx/sites-enabled/default"
      execute :sudo, "service nginx restart"
    end
  end
  after "deploy:setup_config", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do 
      on roles(:app) do
        execute :sudo, "service nginx #{command}"
      end
    end
  end

end
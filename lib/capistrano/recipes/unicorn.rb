namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      template "unicorn.rb.erb", "#{shared_path}/config/unicorn.rb"
      template "unicorn_init.erb", "/tmp/unicorn_init"
      execute "chmod +x /tmp/unicorn_init"
      execute :sudo, "mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
      execute :sudo, "update-rc.d -f unicorn_#{fetch(:application)} defaults"
    end
  end
  after "deploy:setup_config", "unicorn:setup"
end

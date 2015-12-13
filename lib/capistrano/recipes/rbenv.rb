set :ruby_version, "2.2.2"
set :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install do
    on roles(:app) do
      execute "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
      bashrc = <<-BASHRC
export RBENV_ROOT="${HOME}/.rbenv"
if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
BASHRC
      bashrc = StringIO.new(bashrc)
      upload! bashrc, "/tmp/rbenvrc"
      execute "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
      execute "mv ~/.bashrc.tmp ~/.bashrc"
      execute %q{export PATH="$HOME/.rbenv/bin:$PATH"}
      execute %q{eval "$(rbenv init -)"}
      execute "rbenv #{fetch(:rbenv_bootstrap)}"
      execute "rbenv install #{fetch(:ruby_version)} -s"
      execute "rbenv global #{fetch(:ruby_version)}"
      execute "gem install bundler --no-ri --no-rdoc"
      execute "rbenv rehash"
    end
  end
  after "deploy:install", "rbenv:install"
end

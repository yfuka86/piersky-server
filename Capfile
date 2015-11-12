require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'capistrano/gulp'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require "whenever/capistrano"
require 'slackistrano'


Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/recipes/*.rb').each { |r| import r }

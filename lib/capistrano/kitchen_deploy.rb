require 'capistrano/kitchen_deploy/version'

module Capistrano
  module KitchenDeploy
    require_relative 'kitchen_deploy/certbot'
    require_relative 'kitchen_deploy/database'
    require_relative 'kitchen_deploy/nginx'
    require_relative 'kitchen_deploy/puma'
    require_relative 'kitchen_deploy/upload'
  end
end

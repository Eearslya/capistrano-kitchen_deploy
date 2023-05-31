require 'fileutils'

module Capistrano
  module KitchenDeploy
    module Generators
      class BootstrapGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)
        desc 'Create all of the required configuration files necessary to deploy'

        class_option :hostname, type: :string, required: true, desc: 'The hostname that users will use to access the site'
        class_option :server, type: :string, required: true, desc: 'The address/IP of the server to deploy to'
        class_option :sidekiq, type: :boolean, default: false, desc: 'Whether or not to include Sidekiq configuration'
        class_option :certbot, type: :boolean, default: false, desc: 'Whether or not to enable Certbot'
        class_option :certbot_email, type: :string, desc: 'E-Mail to use for Certbot renewal reminders'

        def setup
          @hostname = options[:hostname]
          @server = options[:server]
          @sidekiq = options[:sidekiq]
          @certbot_enable = options[:certbot]
          @certbot_email = options[:certbot_email]

          raise ArgumentError.new('--certbot_email must be provided when enabling Certbot!') if @certbot_enable && @certbot_email.strip.empty?
        end

        def create_capfile
          template 'Capfile.erb', 'Capfile'
        end

        def create_deploy_configs
          FileUtils.mkdir_p 'config/deploy'
          template 'deploy.rb.erb', 'config/deploy.rb'
          template 'production.rb.erb', 'config/deploy/production.rb'
          # template 'staging.rb.erb', 'config/deploy/staging.rb'
        end

        def create_local_configs
          FileUtils.mkdir_p 'config/deploy/templates'
          base_path = File.expand_path('../templates', __FILE__)

          templates.each do |file|
            copy_file(File.join(base_path, file), "config/deploy/templates/#{file}")
          end
        end

        private

        def templates
          %w(
            nginx_conf.erb
            puma.rb.erb
            puma.service.erb
          )
        end
      end
    end
  end
end

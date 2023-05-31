require 'capistrano/dsl'
require_relative 'template'

namespace :deploy do
  namespace :kitchen do
    task :upload do
      on roles(:app) do
        execute :mkdir, "-p #{shared_path}/config"
        execute :mkdir, "-p /home/#{fetch(:deploy_user)}/.config/systemd/user"

        kitchen_template('database.example.yml', "#{shared_path}/config/database.example.yml")

        if File.exist?(File.join('config', 'master.key'))
          upload! File.join('config', 'master.key'), File.join(shared_path, 'config', 'master.key')
        end
      end
    end

    task :enable_linger do
      on roles(:app) do
        if fetch(:puma_systemctl_user) != :system
          sudo 'loginctl enable-linger'
        end
      end
    end
  end
end

before 'deploy:kitchen:upload', 'deploy:check:directories'
before 'deploy:kitchen:upload', 'deploy:check:linked_dirs'

after 'deploy:kitchen:upload', 'puma:config'
after 'deploy:kitchen:upload', 'puma:nginx_config'
after 'deploy:kitchen:upload', 'puma:systemd:config'
after 'deploy:kitchen:upload', 'puma:systemd:enable'
after 'deploy:kitchen:upload', 'deploy:kitchen:enable_linger'
after 'deploy:kitchen:upload', 'certbot:install'

after 'deploy:kitchen:upload', 'nginx:reload'
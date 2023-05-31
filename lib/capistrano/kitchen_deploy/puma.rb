namespace :puma do
  namespace :systemd do
    desc 'Reload the Puma systemd service via USR1 signal'
    task :reload do
      on roles(fetch(:puma_role)) do
        if fetch(:puma_systemctl_user) == :system
          sudo "#{fetch(:puma_systemctl_bin)} reload-or-restart #{fetch(:puma_service_unit_name)}"
        else
          execute :loginctl, 'enable-linger', fetch(:puma_lingering_user) if fetch(:puma_enable_lingering)
          execute fetch(:puma_systemctl_bin), '--user', 'reload-or-restart', fetch(:puma_service_unit_name)
        end
      end
    end
  end
end

after 'deploy:finished', 'puma:systemd:reload'
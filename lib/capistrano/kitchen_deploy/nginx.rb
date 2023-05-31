namespace :nginx do
  %w(start stop restart reload).each do |cmd|
    desc "#{cmd.capitalize} Nginx"
    task cmd do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "systemctl #{cmd} nginx"
      end
    end
  end
end
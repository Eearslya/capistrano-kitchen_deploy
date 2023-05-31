namespace :certbot do
  desc "Set up and install Certbot certificates"
  task :install do
    on roles(:app) do
      return unless fetch(:certbot_enable_ssl)
      sudo "certbot --nginx -d #{fetch(:nginx_server_name)} --non-interactive --agree-tos --email #{fetch(:certbot_email)} #{fetch(:certbot_redirect_to_https) ? '--redirect' : ''} #{fetch(:certbot_use_acme_staging) ? '--dry-run' : ''}"
    end
  end
end
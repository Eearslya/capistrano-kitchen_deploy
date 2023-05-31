namespace :deploy do
  namespace :kitchen do
    desc 'Fetches the remote database.yml and creates the user/database specified within'
    task :createdb do
      on primary(:db) do |host|
        unless test("[ -f #{shared_path}/config/database.yml ]")
          execute :cp, "#{shared_path}/config/database.example.yml", "#{shared_path}/config/database.yml"
        end

        download! "#{shared_path}/config/database.yml", 'db.tmp.yml', via: :scp
        yaml = YAML.load_file('db.tmp.yml')
        File.delete('db.tmp.yml')
        database_config = yaml[fetch(:rails_env).to_s]

        if test(%Q{sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{database_config['username']}';" | grep -q 1})
          info "Role #{database_config['username']} already exists."
        else
          execute %Q{sudo -u postgres psql -c "CREATE USER #{database_config['username']} WITH PASSWORD '#{database_config['password']}';"}
        end

        if test(%Q{sudo -u postgres psql -lqt | cut -d \\| -f 1 | grep -wq #{database_config['database']}})
          info "Database #{database_config['database']} already exists."
        else
          execute %Q{sudo -u postgres psql -c "CREATE DATABASE #{database_config['database']};"}
          execute %Q{sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE #{database_config['database']} TO #{database_config['username']};"}
        end
      end
    end
  end
end
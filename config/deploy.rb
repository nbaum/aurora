set :application, 'aurora'
set :repo_url, 'aurora@84.45.122.187:repo'
set :use_sudo, nil

set :deploy_to, '/home/aurora'

set :linked_dirs, %w{var tmp}
set :linked_files, %w{.env}

set :keep_releases, 5

namespace :deploy do

  task :restart do
    on roles :root do
      execute :cp, "~aurora/current/aurora.service", "/etc/systemd/system"
      execute :systemctl, "daemon-reload"
      execute :systemctl, "restart aurora"
    end
  end

end

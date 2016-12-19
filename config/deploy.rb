# Copyright (c) 2016 Nathan Baum

lock "3.4.0"

set :application, "aurora"
set :repo_url, "https://github.com/nbaum/aurora.git"
set :use_sudo, nil

set :deploy_to, "/home/aurora"

set :linked_dirs, %w[var tmp]
set :linked_files, %w[.env]

set :keep_releases, 5

namespace :deploy do
  task :restart do
    on roles :app do
      execute :systemctl, "--user daemon-reload"
      execute :systemctl, "--user restart aurora aurora-worker"
    end
  end
end

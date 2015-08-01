# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

lock "3.4.0"

set :application, "aurora"
set :repo_url, "ssh://git@fabric.orbitalinformatics.co.uk/diffusion/A/aurora.git"
set :use_sudo, nil

set :deploy_to, "/home/aurora"

set :linked_dirs, %w[var tmp]
set :linked_files, %w[.env]

set :keep_releases, 5

namespace :deploy do
  task :restart do
    on roles :app do
      host.user = "root"
      execute :cp, "~aurora/current/aurora.service", "/etc/systemd/system"
      execute :systemctl, "daemon-reload"
      execute :systemctl, "restart aurora"
    end
  end
end

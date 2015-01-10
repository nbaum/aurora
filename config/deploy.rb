set :application, 'aurora'
set :repo_url, 'aurora@84.45.122.187:repo'

set :deploy_to, '/home/aurora'

set :linked_dirs, %w{var}

set :keep_releases, 5

namespace :deploy do
end

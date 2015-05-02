set :rvm_roles, [:app]
set :rails_env, 'production'

role :root, %w(
	root@46.30.8.59
), no_release: true

role :app, %w(
	aurora@46.30.8.59
)

role :web, %w(
	aurora@46.30.8.59
)

role :db, %w(
	aurora@46.30.8.59
)

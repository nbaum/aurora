# Copyright (c) 2016 Nathan Baum

set :rvm_roles, [:app]
set :rails_env, "production"

role :app, %w[
  aurora@46.30.14.132
  aurora@46.30.14.133
]

role :web, %w[
  aurora@46.30.14.132
  aurora@46.30.14.133
]

role :db, %w[
  aurora@46.30.14.132
  aurora@46.30.14.133
]

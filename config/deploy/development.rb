# Copyright (c) 2016 Nathan Baum

set :rvm_roles, [:app]
set :rails_env, "production"

server "46.30.8.59", roles: %w[app web db], user: "aurora"

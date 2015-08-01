# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

set :rvm_roles, [:app]
set :rails_env, "production"

server "46.30.8.59", roles: %w[app web db], user: "aurora"

# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd
# -*- mode: ruby

namespace :db do
  task(:reset).clear_actions
  task reset: [:environment] do
    ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE;")
    ActiveRecord::Base.connection.execute("CREATE SCHEMA public;")
  end
end

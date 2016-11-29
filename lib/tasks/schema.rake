# Copyright (c) 2016 Nathan Baum
# -*- mode: ruby

namespace :db do
  task(:reset).clear_actions
  task reset: [:environment] do
    ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE;")
    ActiveRecord::Base.connection.execute("CREATE SCHEMA public;")
  end
end

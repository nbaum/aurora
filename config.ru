# Copyright (c) 2016 Nathan Baum

require ::File.expand_path("../config/environment", __FILE__)
require "job"

Job.running.each do |job|
  job.schedule(:resume)
end

run Rails.application

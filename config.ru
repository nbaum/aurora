# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

require ::File.expand_path("../config/environment",  __FILE__)
require "job"

Job.running.each do |job|
  job.schedule(:resume)
end

run Rails.application

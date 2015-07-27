#\ -w -o 127.0.0.1 -p 9001

require ::File.expand_path('../config/environment',  __FILE__)

Job.running.each do |job|
  job.schedule(:resume)
end

run Rails.application

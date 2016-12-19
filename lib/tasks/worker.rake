namespace :app do
  task run_one_job: [:environment] do
    job = Job.find(ENV["JOB_ID"])
    job.invoke :run
  end
  task worker: [:environment] do
    loop do
      if job = Job.find_by_sql("UPDATE jobs j SET status = 'running' FROM (SELECT id FROM jobs WHERE status = 'pending' ORDER BY id DESC LIMIT 1 FOR UPDATE) j2 WHERE j.id = j2.id RETURNING j.*").first
        sh "bundle exec rake app:run_one_job JOB_ID=#{job.id}"
      end
      sleep 1
    end
  end
end

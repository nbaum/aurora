namespace :app do
  task worker: [:environment] do
    loop do
      if job = Job.find_by_sql("UPDATE jobs j SET status = 'running' FROM (SELECT id FROM jobs WHERE status = 'pending' ORDER BY id DESC LIMIT 1 FOR UPDATE) j2 WHERE j.id = j2.id RETURNING j.*").first
        job.invoke :run
      end
      sleep 1
    end
  end
end

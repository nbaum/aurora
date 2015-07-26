class Job < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :server

  def self.queue
    @queue ||= Queue.new
  end

  def self.ensure_workers_are_running!
    @workers ||= begin
      5.times.map do
        Thread.new do
          while true
            job = queue.pop
            job.update_attributes started_at: Time.now, status: "running"
            begin
              job.run
              job.status = "finished"
            rescue => e
              job.state["error"] = [e.class.name, e.message, e.backtrace]
              job.status = "failed"
            ensure
              job.finished_at = Time.now
              job.save!
            end
          end
        end
      end
    end
  end

  def title
    self.class.name.split("Jobs::")[1]
  end

  def message
    if status == "failed"
      state["error"]
    else
      nil
    end
  end

  def wait
    sleep 0.5
    reload
    return self if state != "running"
  end

  def schedule
    self.class.queue << self
    self.class.ensure_workers_are_running!
  end

  def pending?
    status == "pending"
  end

  def running?
    status == "running"
  end

  def finished?
    status == "finished"
  end

  def failed?
    status == "failed"
  end

end

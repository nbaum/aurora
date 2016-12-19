# Copyright (c) 2016 Nathan Baum

class Job < ActiveRecord::Base

  belongs_to :owner, class_name: "User"
  belongs_to :target, polymorphic: true

  scope :pending, -> { where(status: "pending") }
  scope :running, -> { where(status: "running") }
  scope :failed, -> { where(status: "failed") }
  scope :finished, -> { where(status: "finished") }

  def server
    Server === target ? target : fail("Job doesn't target a server")
  end

  def bundle
    Bundle === target ? target : fail("Job doesn't target a bundle")
  end

  def invoke (action)
    update_attributes started_at: Time.now, status: "running", finished_at: nil
    begin
      puts "#{type}: started"
      send(action)
      state_will_change!
      self.status = "finished"
      puts "#{type}: succeeded"
    rescue => e
      state["error"] = {
        "backtrace" => e.backtrace,
        "message" => e.message,
        "type" => e.class.name,
      }
      state_will_change!
      self.status = "failed"
      puts "#{type}: failed"
    ensure
      self.finished_at = Time.now
      save!
    end
  end

  def title
    self.class.name.split("Jobs::")[1]
  end

  def message
    if status == "failed" && state["error"]
      state["error"]["message"]
    else
      state["message"]
    end
  end

  def wait
    sleep 0.125
    reload
    return wait if state != "running"
    self
  end

  def schedule (action = :run)
    self.class.queue << [self, action]
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

  def resume
    raise "Can't resume job"
  end

end

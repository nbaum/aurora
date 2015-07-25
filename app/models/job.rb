class Job < Hash
  attr_accessor :thread
  attr_accessor :status
  attr_accessor :message
  attr_accessor :started_at
  attr_accessor :finished_at
  attr_accessor :title

  def self.spawn (title, *args, &block)
    new(title).spawn(*args, &block)
  end

  def initialize (title)
    @title = title
  end

  def spawn (*args, &block)
    self.thread = Thread.new do
      begin
        self.started_at = Time.now
        block.(self, *args)
        finish "Done" unless status
      rescue => e
        fail e.message
      ensure
        ActiveRecord::Base.clear_active_connections!
      end
    end
    self
  end

  def wait (s = 0.2)
    if self.thread.join(s)
      self
    else
      nil
    end
  end

  def fail (message)
    self.status = :failed
    self.message = message
    self.finished_at = Time.now
  end

  def finish (message)
    self.status = :finished
    self.message = message
    self.finished_at = Time.now
  end

end

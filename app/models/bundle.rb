# Copyright (c) 2016 Nathan Baum

class Bundle < ActiveRecord::Base

  belongs_to :account
  has_many :servers, dependent: :destroy
  has_many :volumes, dependent: :destroy
  has_many :networks, dependent: :destroy

  def start
    each_server(&:start)
  end

  def pause
    each_server(&:pause)
  end

  def unpause
    each_server(&:unpause)
  end

  def stop
    each_server(&:stop)
  end

  def reset
    each_server(&:reset)
  end

  def clone
    b = Bundle.new(name: name.succ)
    each_server do |s|
      b.servers << s.clone(bundle_id: b)
    end
    b
  end

  private

  def each_server
    servers.each do |s|
      begin
        yield s
      rescue => e
      end
    end
  end

end

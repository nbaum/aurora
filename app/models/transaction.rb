# Copyright (c) 2016 Nathan Baum

class Transaction < ActiveRecord::Base

  belongs_to :account

  KINDS = {
    "admin"   => "Administrative Adjustment",
    "invoice" => "Invoice Transfer",
    "server"  => "Server Charges",
  }.freeze

  PERIODS = {
    "instant" => "Instant",
    "second"  => "Second",
    "minute"  => "Minute",
    "hour"    => "Hour",
    "day"     => "Day",
    "month"   => "Calendar Month",
  }.freeze

  before_save do
    self.closed_at = opened_at if period == "instant"
  end

  def opened_at
    created_at
  end

  def amount (time = Time.now)
    duration(time) * rate
  end

  def duration (time = Time.now)
    adjust_duration (closed_at || time) - created_at
  end

  private

  def adjust_duration (seconds)
    t1 = closed_at || Time.now
    case period
    when "month"
      t = opened_at
      i = -1
      while t < t1
        i += 1
        t = t.advance(months: 1)
      end
      i + (t1 - t.advance(months: -1)) / (t - t.advance(months: -1))
    when "day"
      seconds / 60 * 60 * 24
    when "hour"
      seconds / 60 * 60
    when "minute"
      seconds / 60
    when "second"
      seconds
    when "instant"
      1
    end
  end

end

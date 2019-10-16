#!/usr/bin/env ruby --disable-gems

class Notify
  def self.of(event, time = Time.now)
    new(event: event, time: Time.now)
  end

  def self.at(time)
    new(time: time)
  end

  def initialize(time: Time.now, event: nil)
    @time = time
    @event = event
    @sent = false

    process
  end

  def process
    return unless send?

    # Process.fork {
    #   p [@time, @event]
    # }
    @sent = true
  end

  def of(event)
    @event = event
    process
  end

  def at(time)
    @time = time
    process
  end

  def send?
    !sent? && @event
  end

  def sent?
    @sent
  end
end

Notify.of('qwer')
Notify.at(Time.now + 5).of('thing')
Notify.of('asdf').at(Time.now + 1)

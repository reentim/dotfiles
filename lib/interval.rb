require_relative 'pluralise'

module Interval
  include Pluralise


  def interval(seconds, format: :long)
    case seconds
    when 0..90
      "#{pluralise(seconds.to_i, 'second')}"
    when 90..5400 # 90 minutes
      "#{pluralise(seconds.to_i/60, 'minute')}"
    when 5400..129_600 # 36 hours
      "#{pluralise(seconds.to_i/3600, 'hour')}#{interval(seconds.to_i % 3600) if format == :long}"
    when 129_600..1_209_600 # 2 weeks
      "#{pluralise(seconds.to_i/86_400, 'day')}#{interval(seconds.to_i % 86_400) if format == :long}"
    when 1_209_600..7_257_600 # 12 weeks
      "#{pluralise(seconds.to_i/604_800, 'week')}#{interval(seconds.to_i % 604_800) if format == :long}"
    when
      "#{pluralise(seconds.to_i/2_629_746, 'month')}#{interval(seconds.to_i % 2_629_746) if format == :long}"
    end
  end
end

require_relative 'pluralise'

module Interval
  include Pluralise

  def interval(seconds, format: nil)
    seconds = seconds.to_i
    case seconds
    when 0..90
      "#{pluralise(seconds, 'second')}"
    when 90..minutes(90)
      ["#{pluralise(seconds / minutes(1), 'minute')}",  "#{interval(seconds % minutes(1), format: next_format(format)) if format}"].join(",\s")
    when minutes(90)..hours(36)
      ["#{pluralise(seconds / hours(1), 'hour')}", "#{interval(seconds % hours(1), format: next_format(format)) if format}"].join(",\s")
    when hours(36)..weeks(2)
      ["#{pluralise(seconds / days(1), 'day')}", "#{interval(seconds % days(1), format: next_format(format)) if format}"].join(",\s")
    when weeks(2)..weeks(12)
      ["#{pluralise(seconds / weeks(1), 'week')}", "#{interval(seconds % weeks(1), format: next_format(format)) if format}"].join(",\s")
    when weeks(12)..months(24)
      ["#{pluralise(seconds / months(1), 'month')}", "#{interval(seconds % months(1), format: next_format(format)) if format}"].join(",\s")
    else
      ["#{pluralise(seconds / years(1), 'year')}", "#{interval(seconds % years(1), format: next_format(format)) if format}"].join(",\s")
    end.chomp(",\s")
  end

  private

  def next_format(format)
    nil if format == :long
    :full if format == :full
  end

  def minutes(n)
    n * 60
  end

  def hours(n)
    n * 3600
  end

  def days(n)
    n * 86_400
  end

  def weeks(n)
    n * days(7)
  end

  def months(n)
    (n * years(1) / 12).to_i
  end

  def years(n)
    (n * days(365.2425)).to_i
  end
end

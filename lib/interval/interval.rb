require_relative '../pluralise'

module Interval
  include Pluralise

  def interval(s, format: nil, short: false)
    s = s.to_i
    case s
    when 0..90
      "#{short ? format("%ds", s) : pluralise(s, 'second')}"
    when 90..minutes(90)
      v = s/minutes(1)
      ["#{short ? format("%dm", v) : pluralise(v, 'minute')}",
       "#{interval(s % minutes(1), format: next_format(format)) if format}"].join(",\s")
    when minutes(90)..hours(36)
      v = s/hours(1)
      ["#{short ? format("%dh", v) : pluralise(v, 'hour')}",
       "#{interval(s % hours(1), format: next_format(format)) if format}"].join(",\s")
    when hours(36)..weeks(2)
      v = s/days(1)
      ["#{short ? format("%dd", v) : pluralise(v, 'day')}",
       "#{interval(s % days(1), format: next_format(format)) if format}"].join(",\s")
    when weeks(2)..months(3)
      v = s/weeks(1)
      ["#{short ? format("%dw", v) : pluralise(v, 'week')}",
       "#{interval(s % weeks(1), format: next_format(format)) if format}"].join(",\s")
    when weeks(12)..months(24)
      v = s/months(1)
      ["#{short ? format("%dm", v) : pluralise(v, 'month')}",
       "#{interval(s % months(1), format: next_format(format)) if format}"].join(",\s")
    else
      ["#{pluralise(s / years(1), 'year')}",
       "#{interval(s % years(1), format: next_format(format)) if format}"].join(",\s")
    end.chomp(",\s")
  end

  private

  def significant?(part, whole)
    # todo maybe ideas of, when the integer division of the decided unit would
    # discard over some threshold, the unit is lowered
    whole % part > whole/10
  end

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
    n * 604_800
  end

  def months(n)
    n * 2_629_746
  end

  def years(n)
    n * 31_556_952
  end
end

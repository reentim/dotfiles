module Enumerable
  def tally_by(&block)
    tally = Hash.new(0)
    map { |i| tally[yield(i)] += 1 }
    tally
  end
end

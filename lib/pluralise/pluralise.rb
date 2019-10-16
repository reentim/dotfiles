module Pluralise
  def pluralise(count, word)
    word += 's' if count > 1
    [count, word].join("\s")
  end
end

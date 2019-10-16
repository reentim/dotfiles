module Color
  COLORS = {
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    violet: 35,
    cyan: 36,
    white: 37,
  }

  def color(text, fg = :black)
	"\e[#{COLORS[fg] || fg}m#{text}\e[0m"
  end
end

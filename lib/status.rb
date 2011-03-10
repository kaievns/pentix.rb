#
# This class handles the game status and things like
# the next figure, the score and so one
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Status
  HEAD_FONT  = ['Courier',     25, Color::GRAY].freeze
  TEXT_FONT  = ['Courier New', 20, Color::GRAY].freeze
  TEXT_WIDTH = 22 # chars

  attr_accessor :figure, :pos_x, :pos_y, :level, :lines, :figures, :score

  def initialize(window, x, y)
    @pos_x   = x
    @pos_y   = y

    @head_font  = Font.new(window, HEAD_FONT[0], HEAD_FONT[1])
    @text_font  = Font.new(window, TEXT_FONT[0], TEXT_FONT[1])

    reset!
  end

  def draw
    draw_head "Next:", 0
    @figure.pos_x = @pos_x
    @figure.pos_y = @pos_y + 40
    @figure.draw

    draw_head "Score:",             180
    draw_text "Level",      @level, 200
    draw_text "Score",      @score, 220
    draw_text "Lines",      @lines, 240
    draw_text "Figures",  @figures, 260

    draw_head "Winnars:",           360
    draw_text "Boo hoo!",    10000, 380
    draw_text "Trololo",    999999, 400
    draw_text "Bla bla bla", 44444, 420
  end

  def reset!
    @level   = 0
    @lines   = 0
    @score   = 0
    @figures = 0
  end

private

  def draw_head(text, pos)
    @head_font.draw(text, @pos_x, @pos_y + pos - 5, 0, 1.0, 1.0, HEAD_FONT[2])
  end

  def draw_text(text, value, pos)
    value = "..#{value}"

    @text_font.draw(
      text.ljust(TEXT_WIDTH - value.size, '.') + value,
      @pos_x, @pos_y + pos, 0, 1.0, 1.0, TEXT_FONT[2]
    )
  end

end
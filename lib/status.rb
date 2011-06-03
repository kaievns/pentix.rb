#
# This class handles the game status and things like
# the next figure, the score and so one
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Status
  attr_accessor :figure, :pos_x, :pos_y, :level, :lines, :figures, :score

  HEAD_FONT  = ['Courier',     Block::SIZE + 5, Color::GRAY].freeze
  TEXT_FONT  = ['Courier New', Block::SIZE, Color::GRAY].freeze
  TEXT_WIDTH = 22 # chars

  SCORING_SYSTEM = {
    1 => 100,
    2 => 300,
    3 => 500,
    4 => 800,
    5 => 1200
  }

  LEVELUP = 10 # the number of lines to level up

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
    @figure.pos_y = @pos_y + 2
    @figure.draw

    draw_head "Score:",              9
    draw_text "Level",      @level, 10
    draw_text "Score",      @score, 11
    draw_text "Lines",      @lines, 12
    draw_text "Figures",  @figures, 13

    draw_head "Winnars:",           18
    @records.each_with_index do |entry, i|
      draw_text entry[0], entry[1], 19 + i
    end
  end

  def reset!
    @level   = 1
    @lines   = 0
    @score   = 0
    @figures = 0

    # the next levelup lines num
    @levelup = LEVELUP

    @records = Records.new.top(6)
  end

  def count_drop(figure)
    if figure.distance > 0
      @score   += figure.distance * @level
      @figures += 1
    end
  end

  def count_kill(lines)
    if lines.size > 0
      @score += SCORING_SYSTEM[lines.size] * @level
      @lines += lines.size

      if @lines >= @levelup
        @level  += 1
        @levelup = @lines + LEVELUP - @lines % LEVELUP
      end
    end
  end

private

  #
  # A shortcut to draw a header text
  #
  def draw_head(text, pos)
    @head_font.draw(
      text,   @pos_x * Block::SIZE,
      (@pos_y + pos) * Block::SIZE - 5, # -5 is to shift the too large font a bit
      0, 1.0, 1.0, HEAD_FONT[2]
    )
  end

  #
  # A shortcut to draw a normal text
  #
  def draw_text(text, value, pos)
    value = "..#{value}"
    text  = text.slice(0, TEXT_WIDTH - value.size)

    @text_font.draw(
      text.ljust(TEXT_WIDTH - value.size, '.') + value,
      @pos_x * Block::SIZE, (@pos_y + pos) * Block::SIZE,
      0, 1.0, 1.0, TEXT_FONT[2]
    )
  end

end
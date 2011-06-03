#
# The Game-Over screen
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Finish
  attr_accessor :score, :records

  WIDTH     = 27
  HEIGHT    = 27

  BG_COLOR  = Color::BLACK

  OVER_FONT = ['Courier',     Block::SIZE * 4, Color::RED].freeze
  HEAD_FONT = ['Courier',     Block::SIZE + 5, Color::GRAY].freeze
  TEXT_FONT = ['Courier New', Block::SIZE, Color::GRAY].freeze

  #
  # Basic constructor
  #
  def initialize(window, x, y)
    @window = window
    @block  = Block.new(window, BG_COLOR)

    @pos_x  = x
    @pos_y  = y

    @over_font  = Font.new(window, OVER_FONT[0], OVER_FONT[1])
    @head_font  = Font.new(window, HEAD_FONT[0], HEAD_FONT[1])
    @text_font  = Font.new(window, TEXT_FONT[0], TEXT_FONT[1])

    @score      = 0
    @hiscores   = []
  end

  def draw
    # rendering the black background
    (0..WIDTH).each do |x|
      (0..HEIGHT).each do |y|
        @block.draw(x, y)
      end
    end

    @over_font.draw("GAME OVAR!",
      3.5 * Block::SIZE, 2 * Block::SIZE,
      0, 1.0, 1.0, OVER_FONT[2])

    @head_font.draw("Your score: #{@score}",
      3.5 * Block::SIZE, 7 * Block::SIZE,
      0, 1.0, 1.0, HEAD_FONT[2])

    @head_font.draw("Hiscores: ",
      3.5 * Block::SIZE, 9 * Block::SIZE,
      0, 1.0, 1.0, HEAD_FONT[2])

    @hiscores.each_with_index do |record, i|
      score  = record[1].to_s

      @text_font.draw(
        record[0].ljust(43 - score.size, '.') + score,
        3.5 * Block::SIZE, (11 + i) * Block::SIZE,
        0, 1.0, 1.0, TEXT_FONT[2])
    end
  end

  def records=(list)
    @records  = list
    @hiscores = list.top(13)
  end
end
#
# The Game-Over screen
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Finish
  WIDTH     = 27
  HEIGHT    = 27

  BG_COLOR  = Color::BLACK

  OVER_FONT = ['Courier',     Block::SIZE * 4, Color::RED].freeze
  HEAD_FONT = ['Courier',     Block::SIZE + 5, Color::GRAY].freeze
  TEXT_FONT = ['Courier New', Block::SIZE, Color::GRAY].freeze

  X_OFFSET  = 3.5 * Block::SIZE

  #
  # Basic constructor
  #
  def initialize(window)
    @window = window
    @block  = Block.new(window, BG_COLOR)

    @over_font  = Font.new(window, OVER_FONT[0], OVER_FONT[1])
    @head_font  = Font.new(window, HEAD_FONT[0], HEAD_FONT[1])
    @text_font  = Font.new(window, TEXT_FONT[0], TEXT_FONT[1])

    @text_input = TextInput.new

    reset!
  end

  def draw
    # rendering the black background
    (0..WIDTH).each do |x|
      (0..HEIGHT).each do |y|
        @block.draw(x, y)
      end
    end

    @over_font.draw("GAME OVAR!",
      X_OFFSET, 2 * Block::SIZE,
      0, 1.0, 1.0, OVER_FONT[2])

    @head_font.draw("Hiscores: ",
      X_OFFSET, 7 * Block::SIZE,
      0, 1.0, 1.0, HEAD_FONT[2])

    score = @score.to_s
    text  = @text_input.text.slice(0, 32) + (@window.text_input == @text_input ? '_' : '')
    @text_font.draw(
      text.ljust(43 - score.size, '.') + score,
      X_OFFSET, 9 * Block::SIZE, 0, 1.0, 1.0, Color::WHITE)

    @hiscores.each_with_index do |record, i|
      score  = record[1].to_s

      @text_font.draw(
        record[0].ljust(43 - score.size, '.') + score,
        X_OFFSET, (10 + i) * Block::SIZE,
        0, 1.0, 1.0, TEXT_FONT[2])
    end
  end

  def score=(score)
    @score    = score
    @hiscores = Records.top(14)
    @text_input.text   = Records.last_name if @text_input.text == ''
    @window.text_input = @text_input
  end

  def reset!
    @score    = 0
    @hiscores = []
    @window.text_input = nil
  end

  def enter!
    name = @text_input.text.strip
    unless name == ''
      Records.add(name, @score)
      @window.text_input = nil
    end
  end
end
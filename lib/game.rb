#
# The main game window class
#
# NOTE: all the sizes in the code is _in_blocks_
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Game < Window

  attr_accessor :glass, :status

  def initialize
    super(27 * Block::SIZE, 27 * Block::SIZE, false)
    self.caption = "Pentix"

    @glass    = Glass.new(self,   1, 1) # in blocks!
    @status   = Status.new(self, 16, 1)

    @controls = Controls.new(self)

    reset!
  end

  def draw
    @glass.draw
    @status.draw
    @figure.draw
  end

  def button_down(button)
    case @controls.command_for(button)
      when :drop       then @figure.drop
      when :left       then @figure.move_left
      when :right      then @figure.move_right
      when :turn_left  then @figure.turn_left
      when :turn_right then @figure.turn_right
      when :reset      then reset!
      when :quit       then close
    end
  end

  def reset!
    @status.reset!
    @glass.reset!
    show_next_figure
  end

  def show_next_figure
    @figure        = @status.figure || Figure.new(self)
    @status.figure = Figure.new(self)

    @figure.pos_x  = 2 + (Glass::WIDTH - @figure.size_x)/2
    @figure.pos_y  = 1
  end

end

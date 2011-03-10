#
# The main game window class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Game < Window

  attr_accessor :glass, :status

  def initialize
    super(540, 540, false)
    self.caption = "Pentix"

    @glass    = Glass.new(self,   20, 20)
    @status   = Status.new(self, 320, 20)

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
    show_next_figure
  end

  def show_next_figure
    @figure        = @status.figure || Figure.new(self)
    @status.figure = Figure.new(self)

    @figure.pos_x  = 120 # top-center of the glass
    @figure.pos_y  = 20
  end

end

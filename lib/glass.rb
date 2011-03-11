#
# The glass thing
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Glass
  WIDTH  = 12
  HEIGHT = 24
  COLOR  = Color::GRAY

  attr_accessor :pos_x, :pos_y

  def initialize(window, x, y)
    @block = Block.new(window, COLOR)

    @pos_x  = x
    @pos_y  = y
  end

  def draw
    # drawing the walls
    (0..HEIGHT).each do |i|
      @block.draw(@pos_x,  @pos_y + i)
      @block.draw(@pos_x + WIDTH + 1, @pos_y + i)
    end

    # drawing the bottom
    (1..WIDTH).each do |i|
      @block.draw(@pos_x + i, @pos_y + HEIGHT)
    end
  end
end
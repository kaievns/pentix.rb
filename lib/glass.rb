#
# The glass thing
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Glass
  WIDTH  = 12 # in blocks!
  HEIGHT = 24
  COLOR  = Color::GRAY

  attr_accessor :pos_x, :pos_y

  def initialize(window, x, y)
    @block = Block.new(window, COLOR)

    @pos_x  = x
    @pos_y  = y
    @b_size = @block.size
  end

  def draw
    # drawing the walls
    (0..HEIGHT).each do |i|
      @block.draw(@pos_x,  @pos_y + @b_size * i)
      @block.draw(@pos_x + @b_size * (WIDTH + 1), @pos_y + @b_size * i)
    end

    # drawing the bottom
    (1..WIDTH).each do |i|
      @block.draw(@pos_x + @b_size * i, @pos_y + @b_size * HEIGHT)
    end
  end
end
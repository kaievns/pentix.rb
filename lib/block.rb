#
# A simple block to be used in the figures and the glass
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Block
  attr_accessor :color, :size

  SIZE = 20 # block size in pixels

  def initialize(window, color)
    @@img ||= Image.new(window, 'media/block.png', true)
    @color = color
  end

  def draw(x, y)
    @@img.draw(x * SIZE, y * SIZE, 0, 1.0, 1.0, @color)
  end
end
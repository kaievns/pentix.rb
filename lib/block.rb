#
# A simple block to be used in the figures and the glass
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Block
  attr_accessor :color, :size

  def initialize(window, color)
    @@img ||= Image.new(window, 'media/block.png', true)

    @color = color
    @size  = @@img.width
  end

  def draw(x, y)
    @@img.draw(x, y, 0, 1.0, 1.0, @color)
  end
end
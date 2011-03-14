#
# The glass thing
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Glass
  WIDTH  = 12
  HEIGHT = 24
  COLOR  = Color::GRAY

  attr_accessor :pos_x, :pos_y, :matrix

  def initialize(window, x, y)
    @block = Block.new(window, COLOR)

    @pos_x  = x
    @pos_y  = y

    reset!
  end

  def reset!
    @matrix = (0..HEIGHT-1).map do
      Array.new(WIDTH)
    end
  end

  def draw
    @block.color = COLOR

    # drawing the walls
    (0..HEIGHT).each do |i|
      @block.draw(@pos_x,  @pos_y + i)
      @block.draw(@pos_x + WIDTH + 1, @pos_y + i)
    end

    # drawing the bottom
    (1..WIDTH).each do |i|
      @block.draw(@pos_x + i, @pos_y + HEIGHT)
    end

    # drawing the blocks inside
    @matrix.each_with_index do |row, y|
      row.each_with_index do |color, x|
        unless color == nil
          @block.color = color
          @block.draw(@pos_x + x, @pos_y + y)
        end
      end
    end
  end

  def spaces_below(figure)
    fig_x = figure.pos_x - @pos_x
    fig_y = figure.pos_y - @pos_y

    (0..figure.size_x-1).map do |x|
      column_height = 0

      figure.matrix.each_with_index do |row, y|
        column_height = y + 1 if row[x]
      end

      lowest_point = fig_y + column_height

      x += fig_x
      distance = HEIGHT - lowest_point

      # checking if it interescts with any existing blocks
      @matrix.each_with_index do |row, y|
        if nil != row[x]
          distance = y - column_height
          break
        end
      end

      distance
    end.min
  end

  def glue_in(figure)
    (0..figure.size_x - 1).each do |x|
      (0..figure.size_y-1).each do |y|
        if figure.matrix[y][x]
          @matrix[
            y + figure.pos_y - @pos_y + figure.distance
          ][
            x + figure.pos_x - @pos_x
          ] = figure.color
        end
      end
    end
  end

  def has_space_for?(matrix, pos_x, pos_y)
    if pos_x > @pos_x && pos_x < (@pos_x + WIDTH + 2 - matrix[0].size)
      if pos_y >= @pos_y && pos_y < (@pos_y + HEIGHT + 1 - matrix.size)
        matrix.each_with_index do |row, y|
          row.each_with_index do |visible, x|
            if visible && nil != @matrix[pos_y - @pos_y + y][pos_x - @pos_x + x]
              return false
            end
          end
        end

        return true
      end
    end

    false
  end
end
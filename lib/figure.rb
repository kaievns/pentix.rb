#
# The figure unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Figure
  attr_accessor :name, :color, :matrix, :pos_x, :pos_y, :size_x, :size_y, :distance

  #
  # NOTE! creates a random figure if there is no explicit config
  #
  def initialize(window, name=nil)
    name  ||= FIGURES.keys.shuffle[0]
    config  = FIGURES[name].split('|')

    @pos_x  = 0
    @pos_y  = 0

    @name   = name
    @window = window
    @color  = COLORS[config.pop.to_sym]
    @block  = Block.new(window, @color)

    @matrix = config.map{ |row| row.split('').map{|c| c == 'x'}}

    # getting rid of empty colls and rows
    @matrix.reject!{ |row| row.none? }
    while @matrix.map{ |row| row.last }.none?
      @matrix.each{ |row| row.pop }
    end

    recalc! # precalculates the sizes and distances
  end

  def draw
    @matrix.each_with_index do |row, y|
      row.each_with_index do |visible, x|
        @block.draw(@pos_x + x, @pos_y + y) if visible
      end
    end
  end

  def drop
    @pos_y += Glass::HEIGHT
    return self
  end

  def move_to(x, y)
    @pos_x = x
    @pos_y = y
    recalc!
  end

  def move_left
    move_to(@pos_x - 1, @pos_y)
  end

  def move_right
    move_to(@pos_x + 1, @pos_y)
  end

  def turn_left
    @matrix = (0..size_x-1).map do
      @matrix.map{ |row| row.pop }
    end
    recalc!
  end

  def turn_right
    @matrix = (0..size_x-1).map do
      @matrix.map{ |row| row.shift }.reverse
    end
    recalc!
  end

  def recalc!
    @size_x = @matrix[0].size
    @size_y = @matrix.size

    @distance = @window.glass.spaces_below(self)

    self # sending self-reference back
  end

  FIGURES = {
    :cross     => ' x   |xxx  | x   |     |white',
    :stairs    => 'x    |xx   | xx  |     |yellow',
    :batch     => 'x x  |xxx  |     |     |purple',
    :l_kuckan  => 'xxx  | x   | x   |     |yellow',
    :s_kuckan  => 'xxx  | x   |     |     |yellow',
    :l_corner  => 'x    |x    |xxx  |     |white',
    :s_corner  => 'x    |xx   |     |     |white',
    :l_square  => 'xx   |xx   |     |     |blue',
    :s_square  => 'x    |     |     |     |blue',
    :l_cap     => ' xx  |xxx  |     |     |blue',
    :r_cap     => 'xx   |xxx  |     |     |blue',
    :l_peris   => 'xx   | x   | xx  |     |green',
    :r_peris   => ' xx  | x   |xx   |     |purple',
    :l_zigota  => 'x    |xxx  | x   |     |green',
    :r_zigota  => '  x  |xxx  | x   |     |cyan',
    :ll_worm   => 'xx   | xxx |     |     |green',
    :lr_worm   => '  xx |xxx  |     |     |cyan',
    :sl_worm   => 'xx   | xx  |     |     |green',
    :sr_worm   => ' xx  |xx   |     |     |cyan',
    :l_crutch  => 'x    |xx   |x    |x    |white',
    :r_crutch  => ' x   |xx   | x   | x   |yellow',
    :sl_hook   => 'xxx  |x    |     |     |cyan',
    :sr_hook   => 'x    |xxx  |     |     |white',
    :ll_hook   => 'xxxx |x    |     |     |cyan',
    :lr_hook   => 'x    |xxxx |     |     |yellow',
    :t_stick   => 'xx   |     |     |     |red',
    :s_stick   => 'xxx  |     |     |     |red',
    :l_stick   => 'xxxx |     |     |     |red',
    :h_stick   => 'xxxxx|     |     |     |red'
  }.freeze

  COLORS = {
    :cyan   => 0xFF00F7F1,
    :blue   => 0xFF0000FF,
    :orange => 0xFFF69F00,
    :yellow => 0xFFEAF800,
    :green  => 0xFF00FF00,
    :purple => 0xFFB200F8,
    :red    => 0xFFFE0000,
    :white  => 0xFFFFFFFF
  }.freeze

end
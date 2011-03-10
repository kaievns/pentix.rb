#
# The figure unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Figure
  attr_accessor :name, :color, :matrix, :pos_x, :pos_y, :size_x, :size_y

  INDEXES = [0,1,2,3,4].freeze # just a list of numbers to speed up loops

  #
  # NOTE! creates a random figure if there is no explicit config
  #
  def initialize(window, name=nil)
    name  ||= FIGURES.keys.shuffle[0]
    config  = FIGURES[name].split('|')

    @name   = name
    @block  = Block.new(window, COLORS[config.pop.to_sym])
    @matrix = config.map{ |row| row.split('').map{ |char| char == 'x' }}
    @b_size = @block.size
    @window = window
    @pos_x  = 0
    @pos_y  = 0

    center!
  end

  def draw
    INDEXES.each do |i|
      INDEXES.each do |j|
        if @matrix[i][j]
          @block.draw(@pos_x + j * @b_size, @pos_y + i * @b_size)
        end
      end
    end
  end

  def drop
    @window.show_next_figure
  end

  def move_left
    @pos_x -= @b_size
  end

  def move_right
    @pos_x += @b_size
  end

  def turn_left
    @matrix = INDEXES.map do |i|
      INDEXES.map{ |j| @matrix[j][4 - i] }
    end

    center!
  end

  def turn_right
    @matrix = INDEXES.map do |i|
      INDEXES.map{ |j| @matrix[4 - j][i] }
    end

    center!
  end

  # centers the figure in the matrix and calculates the size
  def center!
    # moving the figure to the top edge
    while @matrix[0].none?
      @matrix << @matrix.shift
    end

    # moving the figure to the left edge
    while INDEXES.map{ |i| @matrix[i][0] }.none?
      INDEXES.each do |i|
        @matrix[i] << @matrix[i].shift
      end
    end

    # measuring the sizes
    @size_x, @size_y = 0, 0
    INDEXES.each do |i|
      @size_y += 1 if @matrix[i].any?
      @size_x += 1 if INDEXES.map{ |j| @matrix[j][i] }.any?
    end

    # centering the figure by the top edge
    ((5 - @size_x)/2).times do |j|
      INDEXES.each do |i|
        @matrix[i].unshift(@matrix[i].pop)
      end
    end
  end

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

  FIGURES = {
    :cross     => ' x   |xxx  | x   |     |     |white',
    :stairs    => 'x    |xx   | xx  |     |     |yellow',
    :batch     => 'x x  |xxx  |     |     |     |purple',
    :l_kuckan  => 'xxx  | x   | x   |     |     |yellow',
    :s_kuckan  => 'xxx  | x   |     |     |     |yellow',
    :l_corner  => 'x    |x    |xxx  |     |     |white',
    :s_corner  => 'x    |xx   |     |     |     |white',
    :l_square  => 'xx   |xx   |     |     |     |blue',
    :s_square  => 'x    |     |     |     |     |blue',
    :l_cap     => ' xx  |xxx  |     |     |     |blue',
    :r_cap     => 'xx   |xxx  |     |     |     |blue',
    :l_peris   => 'xx   | x   | xx  |     |     |green',
    :r_peris   => ' xx  | x   |xx   |     |     |purple',
    :l_zigota  => 'x    |xxx  | x   |     |     |green',
    :r_zigota  => '  x  |xxx  | x   |     |     |cyan',
    :ll_worm   => 'xx   | xxx |     |     |     |green',
    :lr_worm   => '  xx |xxx  |     |     |     |cyan',
    :sl_worm   => 'xx   | xx  |     |     |     |green',
    :sr_worm   => ' xx  |xx   |     |     |     |cyan',
    :l_crutch  => 'x    |xx   |x    |x    |     |white',
    :r_crutch  => ' x   |xx   | x   | x   |     |yellow',
    :sl_hook   => 'xxx  |x    |     |     |     |cyan',
    :sr_hook   => 'x    |xxx  |     |     |     |white',
    :ll_hook   => 'xxxx |x    |     |     |     |cyan',
    :lr_hook   => 'x    |xxxx |     |     |     |yellow',
    :t_stick   => 'xx   |     |     |     |     |red',
    :s_stick   => 'xxx  |     |     |     |     |red',
    :l_stick   => 'xxxx |     |     |     |     |red',
    :h_stick   => 'xxxxx|     |     |     |     |red'
  }.freeze

end
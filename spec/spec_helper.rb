require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'pentix.rb')

# need a single global test-window
$test_window = Window.new(100, 100, false)

#
# Some pretty formatted matrixes handling helpers
#
module MatrixHelper
  def str_to_matrix(str)
    str.scan(/\s*\|(.+?)\|/).map do |line|
      line[0].split('.').map{ |c| c != ' ' }
    end
  end

  def matrix_to_str(matrix)
    matrix.map do |row|
      "|#{row.map{ |c| c ? 'x' : ' '}.join('.')}|"
    end.join("\n          ")
  end

  def draw_matrix(figure)
    block  = actual.instance_variable_get('@block')
    matrix = figure.instance_variable_get('@matrix')
    result = []
    max_x  = 0

    block.class.instance_eval do
      define_method :draw do |x, y|
        x = x - figure.pos_x
        y = y - figure.pos_y

        result[y]  ||= []
        result[y][x] = true
        max_x = x if max_x < x
      end
    end

    figure.draw

    # making the size of the rows even
    result.map do |row|
      (row || []).tap do |row|
        (0..max_x).each do |x|
          row[x] = false unless row[x]
        end
      end
    end
  end
end

#
# Figures rendering matcher
#
RSpec::Matchers.define :render_blocks do |expected|
  extend MatrixHelper

  match do |actual|
    draw_matrix(actual) == str_to_matrix(expected)
  end

  failure_message_for_should do |actual|
    "expected: #{matrix_to_str(str_to_matrix(expected))}\n\n" \
    "     got: #{matrix_to_str(draw_matrix(actual))}"
  end
end


#
# a readable matrix matcher
#
RSpec::Matchers.define :have_matrix do |expected|
  extend MatrixHelper

  match do |actual|
    actual.matrix == str_to_matrix(expected)
  end

  failure_message_for_should do |actual|
    "expected: #{matrix_to_str(str_to_matrix(expected))}\n\n" \
    "     got: #{matrix_to_str(actual.matrix)}"
  end
end
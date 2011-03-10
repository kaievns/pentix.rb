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
    "|#{
      matrix.map do |row|
        row.map{ |c| c ? 'x' : ' '}.join('')
      end.join('|')
    }|"
  end
end

#
# Figures rendering matcher
#
RSpec::Matchers.define :render_blocks do |expected|
  extend MatrixHelper

  match do |actual|
    block = actual.instance_variable_get('@block')

    str_to_matrix(expected).each_with_index do |row, y|
      row.each_with_index do |cell, x|
        block.send(
          cell ? :should_receive : :should_not_receive,
          :draw
        ).with(
          actual.pos_x + block.size * x,
          actual.pos_y + block.size * y
        )
      end
    end

    actual.draw
  end

  failure_message_for_should do |actual|
    "some blocks were misplaced during the rendering process"
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
    "expected: #{matrix_to_str(actual.matrix)}\n" \
    "     got: #{matrix_to_str(str_to_matrix(expected))}"
  end
end
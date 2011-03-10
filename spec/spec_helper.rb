require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'pentix.rb')

# need a single global test-window
$test_window = Window.new(100, 100, false)

#
# a readable matrix matcher
#
RSpec::Matchers.define :have_matrix do |expected|
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

  match do |actual|
    actual.matrix == str_to_matrix(expected)
  end

  failure_message_for_should do |actual|
    "expected: #{matrix_to_str(actual.matrix)}\n" \
    "     got: #{matrix_to_str(str_to_matrix(expected))}"
  end

  description do
    "have matrix: #{matrix_to_str(str_to_matrix(expected))}"
  end
end
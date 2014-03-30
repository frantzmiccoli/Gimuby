require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/foxholes/foxholes'

class TestFoxholes < AbstractTestCase

  def test_evaluate
    foxholes = Foxholes.new

    average_value = 0
    n = 10
    n.times do |_|
      # don't consider the name of the function,
      x_values = foxholes.send(:get_random_coordinates)
      average_value += foxholes.evaluate(x_values)
    end
    average_value /= 10

    hole_coordinates = foxholes.send(:get_holes_coordinates)[0]
    hole_value = foxholes.evaluate(hole_coordinates)

    self.assert(hole_value > average_value, 'The hole should match a local maxima')
  end

end
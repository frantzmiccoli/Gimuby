require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/rastrigin/rastrigin'

class TestRastrigin < AbstractTestCase

  def test_limit
    10.times do |_|
      perform_one_test_limit
    end
  end

  protected

  def perform_one_test_limit
    x_values_size = 20.0
    x_values_dimension_max = 5.12
    x_values_dimension_min = -5.12
    x_values = get_x_values(x_values_size, x_values_dimension_min, x_values_dimension_max)

    rastrigin = Rastrigin.new
    a = rastrigin.send(:get_a)

    const_term = a * x_values_size
    theorical_min = const_term + (0.0 ** 2.0 - a) * x_values_size
    theorical_max = const_term + (x_values_dimension_max ** 2.0 + a) * x_values_size
    value = rastrigin.evaluate(x_values)

    self.assert(value >= theorical_min, 'Value should be above theorical_min')
    self.assert(value <= theorical_max, 'Value should be below theorical_max')
  end

  def get_x_values(size, min, max)
    x_values = []
    scale = max - min
    size.to_i.times do
      x_values.push((rand() * scale) + min)
    end
    x_values
  end

end
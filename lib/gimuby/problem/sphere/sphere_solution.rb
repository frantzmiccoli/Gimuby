require 'gimuby/problem/sphere/sphere'
require 'gimuby/genetic/solution/function_based_solution'

class SphereSolution < FunctionBasedSolution

  def evaluate
    get_sphere.evaluate(@x_values.clone)
  end

  protected

  def get_x_value_min
    -5.12
  end

  def get_x_value_max
    5.12
  end

  def get_dimension_number
    2
  end

  def get_sphere
    Sphere.new
  end
end
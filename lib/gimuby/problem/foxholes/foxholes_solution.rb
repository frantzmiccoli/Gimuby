require 'gimuby/dependencies'
require 'gimuby/config'
require 'gimuby/genetic/solution/function_based_solution'

class FoxholesSolution < FunctionBasedSolution

  def evaluate
    get_foxholes.evaluate(@x_values.clone)
  end

  protected

  def get_x_value_min
    -65536
  end

  def get_x_value_max
    65536
  end

  def get_dimension_number
    2
  end

  def get_foxholes
    # load through dependency
    $dependencies.foxholes
  end
end
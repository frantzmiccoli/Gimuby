require 'gimuby/config'
require 'gimuby/problem/rosenbrock/rosenbrock'
require 'gimuby/genetic/solution/function_based_solution'
require 'gimuby/genetic/solution/check_strategy/solution_space_check_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/combined_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/parent_range_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/average_new_generation_strategy'
require 'gimuby/genetic/solution/mutation_strategy/solution_space_mutation_strategy'

class RosenbrockSolution < FunctionBasedSolution

  def initialize(x_values = nil)
    super(x_values)
  end

  def evaluate
    get_rosenbrock.evaluate(@x_values.clone)
  end

  protected

  def get_x_value_min
    -2.0
  end

  def get_x_value_max
    2.0
  end

  def get_dimension_number
    2
  end

  def get_rosenbrock
    Rosenbrock.new
  end

end

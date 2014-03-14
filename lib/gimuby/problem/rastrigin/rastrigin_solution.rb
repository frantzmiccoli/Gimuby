require 'gimuby/config'
require 'gimuby/problem/rastrigin/rastrigin'
require 'gimuby/genetic/solution/function_based_solution'
require 'gimuby/genetic/solution/check_strategy/solution_space_check_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/combined_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/parent_range_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/average_new_generation_strategy'
require 'gimuby/genetic/solution/mutation_strategy/solution_space_mutation_strategy'

class RastriginSolution < FunctionBasedSolution

  def evaluate
    get_rastrigin.evaluate(@x_values)
  end

  protected

  def get_x_value_min
    -5.12
  end

  def get_x_value_max
    5.12
  end

  def get_dimension_number
    $config.rastrigin_dimension
  end

  def get_rastrigin
    Rastrigin.new
  end

end

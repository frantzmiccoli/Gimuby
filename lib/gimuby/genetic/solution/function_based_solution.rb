require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/solution/check_strategy/solution_space_check_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/combined_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/parent_range_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/average_new_generation_strategy'
require 'gimuby/genetic/solution/mutation_strategy/solution_space_mutation_strategy'

class FunctionBasedSolution < Solution

  def initialize(x_values = nil)
    super(x_values)

    @check_strategy = SolutionSpaceCheckStrategy.new
    @check_strategy.set_min(get_x_value_min)
    @check_strategy.set_max(get_x_value_max)

    @new_generation_strategy = CombinedNewGenerationStrategy.new
    @new_generation_strategy.add_strategy(ParentRangeNewGenerationStrategy.new)
    @new_generation_strategy.add_strategy(CrossOverNewGenerationStrategy.new)
    @new_generation_strategy.add_strategy(AverageNewGenerationStrategy.new)

    @mutation_strategy = SolutionSpaceMutationStrategy.new
    @mutation_strategy.set_min(get_x_value_min)
    @mutation_strategy.set_max(get_x_value_max)
  end

  def evaluate
    raise NotImplementedError
  end

  def get_solution_representation
    @x_values.clone
  end

  def set_solution_representation(x_values)
    @x_values = x_values.clone
  end

  protected

  def init_representation
    @x_values = []
    dimension = get_dimension_number
    dimension.times do |_|
      range = get_x_value_max - get_x_value_min
      x_value = (rand() * range) + get_x_value_min
      @x_values.push(x_value)
    end
  end

  def get_x_value_min
    raise NotImplementedError
  end

  def get_x_value_max
    raise NotImplementedError
  end

  def get_dimension_number
    raise NotImplementedError
  end

end

require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/solution/check_strategy/permutation_check_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'
require 'gimuby/genetic/solution/mutation_strategy/permutation_mutation_strategy'

class SolutionMock < Solution

  def initialize(representation = nil)
    @check_strategy = PermutationCheckStrategy.new()
    @new_generation_strategy = CrossOverNewGenerationStrategy.new()
    @mutation_strategy = PermutationMutationStrategy.new()
    super(representation)
  end

  def init_representation

  end

  def get_solution_representation

  end

  def set_solution_representation(representation)

  end
end
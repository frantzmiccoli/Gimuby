require 'gimuby/dependencies'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/solution/check_strategy/permutation_check_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'
require 'gimuby/genetic/solution/mutation_strategy/permutation_mutation_strategy'

class TspSolution < Solution

  def initialize(permutation = nil)
    @check_strategy = PermutationCheckStrategy.new()
    @new_generation_strategy = CrossOverNewGenerationStrategy.new()
    @mutation_strategy = PermutationMutationStrategy.new()
    super(permutation)
    check
  end

  attr_accessor :permutation

  def evaluate
    get_tsp.get_permutation_distance(@permutation)
  end

  def get_solution_representation
    @permutation.clone
  end

  def set_solution_representation(representation)
    @permutation = representation.clone
  end

  protected

  def init_representation
    @permutation = get_not_randomized_permutation
    @permutation = @permutation.shuffle
  end

  def get_not_randomized_permutation
    _ = *(0..get_tsp.get_number_of_points - 1)
  end

  def get_tsp
    $dependencies.tsp
  end

end

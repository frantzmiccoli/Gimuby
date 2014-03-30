

class MutationStrategy

  def initialize(mutation_rate = 0.01)
    @mutation_rate = mutation_rate
  end

  attr_accessor :mutation_rate

  def mutate(solution)
    if rand < @mutation_rate
      perform_mutation(solution)
      solution.reset_fitness_state
    end
  end

  def perform_mutation(solution)
    raise NotImplementedError
  end

end
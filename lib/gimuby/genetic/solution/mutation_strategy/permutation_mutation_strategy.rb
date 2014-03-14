require 'gimuby/genetic/solution/mutation_strategy/mutation_strategy'

class PermutationMutationStrategy < MutationStrategy

  def perform_mutation(solution)
    permutation = solution.get_solution_representation
    begin
      index1 = rand(permutation.length)
      index2 = rand(permutation.length)
    end while index1 == index2
    tmp = permutation[index1]
    permutation[index1] = permutation[index2]
    permutation[index2] = tmp
    solution.set_solution_representation(permutation)
  end

end

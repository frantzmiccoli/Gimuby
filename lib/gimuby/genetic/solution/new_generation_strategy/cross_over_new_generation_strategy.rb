require 'gimuby/genetic/solution/new_generation_strategy/new_generation_strategy'

class CrossOverNewGenerationStrategy < NewGenerationStrategy

  def initialize(cross_overs_number = 1)
    @cross_overs_number = cross_overs_number
  end

  def reproduce(solution1, solution2)
    permutation1 = solution1.get_solution_representation
    permutation2 = solution2.get_solution_representation
    cross_overs_number = @cross_overs_number
    if cross_overs_number <= 0
      cross_overs_number = permutation1.length - cross_overs_number
    end
    cross_overs_number.times do |_|
      r = reproduce_step(permutation1, permutation2)
      permutation1 = r.shift
      permutation2 = r.shift
    end
    [permutation1, permutation2]
  end

  protected

  def reproduce_step(permutation1, permutation2)
    random_index = rand(permutation1.length)
    if random_index == permutation1.length - 1
      new_permutation1 = permutation1.clone()
      new_permutation2 = permutation2.clone()
    else
      new_permutation1 = permutation1[0..random_index] +
          permutation2[random_index + 1..-1]
      new_permutation2 = permutation2[0..random_index] +
          permutation1[random_index + 1..-1]
    end
    [new_permutation1, new_permutation2]
  end

end
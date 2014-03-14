require 'gimuby/genetic/solution/new_generation_strategy/new_generation_strategy'

class AverageNewGenerationStrategy < NewGenerationStrategy

  # @param best_weight {Float} The weight given to the best solution
  def initialize(best_weight = 1.0)
    @best_weight = best_weight
  end

  def reproduce(solution1, solution2)
    weight1 = 1.0
    weight2 = 1.0
    if solution1.get_fitness < solution2.get_fitness
      weight1 = @best_weight
    else
      weight2 = @best_weight
    end
    x_values1 = solution1.get_solution_representation
    x_values2 = solution2.get_solution_representation
    reproduce_from_representation(x_values1, x_values2, weight1, weight2)
  end

  protected

  def reproduce_from_representation(x_values1, x_values2, weight1, weight2)
    x_values = []
    x_values1.each_index do |i|
      x_value1 = x_values1[i]
      x_value2 = x_values2[i]
      if x_value1.class == Array
        x_value = reproduce_from_representation(x_value1, x_value2, weight1, weight2).pop()
      else
        x_value = x_value1 * weight1 + x_value2 * weight2
        x_value /= (weight1 + weight2)
      end
      x_values.push(x_value)
    end
    [x_values]
  end

end
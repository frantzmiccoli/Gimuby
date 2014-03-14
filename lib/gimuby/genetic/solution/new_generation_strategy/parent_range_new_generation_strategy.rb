require 'gimuby/genetic/solution/new_generation_strategy/new_generation_strategy'


class ParentRangeNewGenerationStrategy < NewGenerationStrategy

  def initialize(widen_range_ratio = 1.10)
    @widen_range_ratio = widen_range_ratio
  end

  def reproduce(solution1, solution2)
    x_values1 = solution1.get_solution_representation
    x_values2 = solution2.get_solution_representation
    reproduce_from_representation(x_values1, x_values2)
  end

  protected

  def reproduce_from_representation(x_values1, x_values2)
    new_values = []
    x_values1.each_index do |i|
      x_value1 = x_values1[i]
      x_value2 = x_values2[i]
      if x_value1.class == Array
        new_x_value = reproduce_from_representation(x_value1, x_value2).pop
      else
        new_x_value = rand_in([x_value1, x_value2])
      end
      new_values.push(new_x_value)
    end
    [new_values]
  end

  def rand_in(values)
    min = values.min
    max = values.max
    range = max - min
    delta_range = range * @widen_range_ratio
    range += delta_range
    (rand() * range) + (min - delta_range / 2)
  end

end
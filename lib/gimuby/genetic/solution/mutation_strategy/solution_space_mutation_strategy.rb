require 'gimuby/genetic/solution/mutation_strategy/mutation_strategy'

class SolutionSpaceMutationStrategy < MutationStrategy

  def initialize(mutation_rate = 0.01)
    super(mutation_rate)
    @default_min = nil
    @default_max = nil
    @mins = {}
    @maxs = {}
  end

  def perform_mutation(solution)
    x_values = solution.get_solution_representation
    x_values = perform_mutation_from_representation(x_values)
    solution.set_solution_representation(x_values)
  end

  def set_min(min, index = nil)
    if index.nil?
      @default_min = min
    else
      @mins[index] = min
    end
  end

  def set_max(max, index = nil)
    if index.nil?
      @default_max = max
    else
      @maxs[index] = max
    end
  end

  protected

  def perform_mutation_from_representation(x_values)
    index = rand(x_values.length)

    x_value = x_values[index]
    if x_value.class == Array
      x_value = perform_mutation_from_representation(x_value)
    else
      min = get_min(index)
      max = get_max(index)
      range = max - min
      x_value = rand() * range + min
    end
    x_values[index] = x_value
    x_values
  end

  def get_min(index)
    min = @default_min
    if @mins.has_key?(index)
      min = @mins[index]
    end
    min
  end

  def get_max(index)
    max = @default_max
    if @maxs.has_key?(index)
      max = @maxs[index]
    end
    max
  end

end
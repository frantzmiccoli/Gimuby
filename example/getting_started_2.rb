require 'gimuby'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/solution/mutation_strategy/mutation_strategy'

# This more complex example shows how to implement a more complex problem like
# splitting elements into two set with as little difference as possible

# Step 1: implement a class that will represent a problem

class ArraySplitProblem

  def initialize
    @values = [-12,32,42,0,0,-1,4,27,30,22,76,12,11,27]
  end

  def evaluate(list_of_indexes)
    if (list_of_indexes.length.to_f - @values.length.to_f / 2.0).abs >= 1
      raise Exception.new('Unexpected list_of_indexes, invalid solution')
    end

    sum_1 = 0
    sum_2 = 0
    (0..@values.length - 1).each do |index|
      if list_of_indexes.include? index
        sum_1 += @values[index]
      else
        sum_2 += @values[index]
      end
    end
    (sum_1 - sum_2).abs
  end

  def get_values_number
    @values.length
  end

end

$array_split_problem = ArraySplitProblem.new


# Step 2: Create a solution class to represent your objects, the encoding of
# your solution is half of the job. For example we could have chosen another
# representation here: an array like [0,1,1,...] where 0 indicates that the item
# is in split 0, 1 that the item is in split 1

# We need a mutation strategy which is to simply remove one element
# and let the check strategy fix the thing
class RemoveOneMutationStrategy < MutationStrategy

  # @param solution Solution
  def perform_mutation(solution)
    representation = solution.get_solution_representation
    representation.delete representation.choice
    solution.set_solution_representation representation
  end

end

# Here is our concrete implementation strategy
class ArraySplitSolution < Solution

  def initialize(picked_indexes = nil)
    @check_strategy = nil
    @new_generation_strategy = CrossOverNewGenerationStrategy.new()
    @mutation_strategy = RemoveOneMutationStrategy.new
    super(picked_indexes)
  end

  def evaluate
    $array_split_problem.evaluate(@picked_indexes)
  end

  def get_solution_representation
    @picked_indexes.clone
  end

  def set_solution_representation(representation)
    @picked_indexes = representation.clone
    check
  end

  protected

  def init_representation
    @picked_indexes = []
    check
  end

  def check
    # we remove duplicates
    @picked_indexes.uniq!

    # we add missing indexes until we have elements enough
    values_number = $array_split_problem.get_values_number
    available_indexes = get_potential_indexes
    while @picked_indexes.length < values_number / 2
      try_with = available_indexes.choice
      unless @picked_indexes.include? try_with
        @picked_indexes.push(try_with)
      end
    end
  end

  def get_potential_indexes
    values_number = $array_split_problem.get_values_number
    potential_indexes = *(0..values_number - 1)
    potential_indexes
  end

end


# STEP 3: Let's optimize it with an optimal population
factory = Gimuby.get_factory
factory.optimal_population = TRUE
# We inject a block that will provide solutions inside our population
optimizer = factory.get_population {next ArraySplitSolution.new}

100.times do
  optimizer.generation_step
end


# STEP 4: We get back the found solution
puts '[' + optimizer.get_best_solution.get_solution_representation.join(',') + ']'
puts optimizer.get_best_fitness

require './abstract_test_case'
require './mock/solution_mock'
require 'gimuby/genetic/solution/mutation_strategy/solution_space_mutation_strategy'

class TestSolutionSpaceMutationStrategy < AbstractTestCase

  def test_mutate
    solution = get_solution
    solution.mutation_strategy = get_mutation_strategy

    solution.set_solution_representation([0.4, 12])
    solution.mutate
    after_mutation = solution.get_solution_representation
    assert(after_mutation.include?(0.4) || after_mutation.include?(12),
           'One value should be preserved')
    assert((! after_mutation.include?(0.4))\
            || (! after_mutation.include?(12)),
           'One value should have changed')

    after_mutation.each do |x_value|
      assert((x_value >= 0.3) && (x_value <= 100),
             'Value should be in the range')
    end
  end

  def get_solution
    PermutationMutationStrategySolutionMock.new
  end

  def get_mutation_strategy
    # Will always mutate
    mutation_strategy = SolutionSpaceMutationStrategy.new(1.0)
    mutation_strategy.set_min(0.3)
    mutation_strategy.set_max(100)
    mutation_strategy
  end
end

private

class SolutionSpaceMutationStrategySolutionMock < SolutionMock

  def init_representation
    @x_values = [1,2]
  end

  def get_solution_representation
    @x_values
  end

  def set_solution_representation(representation)
    @x_values = representation
  end
end
require './abstract_test_case'
require './mock/solution_mock'
require 'gimuby/genetic/solution/mutation_strategy/permutation_mutation_strategy'

class TestPermutationMutationStrategy < AbstractTestCase

  def test_mutate
    solution = get_solution
    solution.mutation_strategy = get_mutation_strategy

    before_mutation = solution.get_solution_representation.clone
    solution.mutate
    after_mutation = solution.get_solution_representation
    assert_not_equal(before_mutation, after_mutation,
                     'Representation should have changed')

    changed_indexes = 0
    before_mutation.each do |value|
      if before_mutation.index(value) != after_mutation.index(value)
        changed_indexes += 1
      end
    end

    assert_equal(2, changed_indexes, 'Two indexes should have changed')
  end

  def get_solution
    PermutationMutationStrategySolutionMock.new
  end

  def get_mutation_strategy
    PermutationMutationStrategy.new(1.0) # <-- will mutate always
  end
end

private

class PermutationMutationStrategySolutionMock < SolutionMock

  def init_representation
    @permutation = *(0..3)
    @permutation.shuffle!
  end

  def get_solution_representation
    @permutation
  end

  def set_solution_representation(representation)
    @permutation = representation
  end
end
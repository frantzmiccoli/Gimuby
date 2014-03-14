require './abstract_test_case'
require './mock/solution_mock'
require 'gimuby/genetic/solution/check_strategy/permutation_check_strategy'

class TestPermutationCheckStrategy < AbstractTestCase

  def test_check
    solution = get_solution
    solution.check_strategy = get_check_strategy
    solution.set_solution_representation([0] * 4)
    solution.send(:check)

    assert(solution.get_solution_representation.include?(0),
          'Every value should be present')
    assert(solution.get_solution_representation.include?(1),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(2),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(3),
           'Every value should be present')

    solution = get_solution
    solution.check_strategy = get_check_strategy
    solution.set_solution_representation([0, 2, 2, 3])
    solution.send(:check)

    assert(solution.get_solution_representation.include?(0),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(1),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(2),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(3),
           'Every value should be present')

    solution = get_solution
    solution.check_strategy = get_check_strategy
    solution.set_solution_representation([0, 2, 1, 3])
    solution.send(:check)

    assert(solution.get_solution_representation.include?(0),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(1),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(2),
           'Every value should be present')
    assert(solution.get_solution_representation.include?(3),
           'Every value should be present')
  end

  def get_solution
    PermutationCheckStrategySolutionMock.new
  end

  def get_check_strategy
    PermutationCheckStrategy.new
  end

end

private

class PermutationCheckStrategySolutionMock < SolutionMock

  def init_representation
     @permutation = [0] * 4
  end

  def get_solution_representation
    @permutation
  end

  def set_solution_representation(representation)
    @permutation = representation
  end
end
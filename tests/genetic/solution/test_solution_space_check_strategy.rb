require './abstract_test_case'
require 'gimuby/genetic/solution/check_strategy/solution_space_check_strategy'
require './mock/solution_mock'

class TestSolutionSpaceCheckStrategy < AbstractTestCase

  def test_check
    solution = get_solution
    solution.check_strategy = get_check_strategy
    solution.set_solution_representation([-12, 3, 10])
    solution.send(:check)

    assert(solution.get_solution_representation.include?(3),
          'Old value should be preserved')
    assert(solution.get_solution_representation.include?(10),
          'Old value should be preserved')
    assert(! solution.get_solution_representation.include?(-12),
          'Out of space value should be removed')

    solution.set_solution_representation([-12, -30, 10])
    solution.check_strategy.set_min(-15.0, 0) # Specific for index 0
    solution.send(:check)

    assert(! solution.get_solution_representation.include?(-30),
           'Out of space value should be removed')
    assert(solution.get_solution_representation.include?(10),
           'Old value should be preserved')
    assert(solution.get_solution_representation.include?(-12),
           'Old value should be preserved')
  end

  def get_solution
    SolutionSpaceCheckStrategySolutionMock .new
  end

  def get_check_strategy
    check_strategy = SolutionSpaceCheckStrategy.new
    check_strategy.set_min(-10.0)
    check_strategy.set_max(10.0)
    check_strategy
  end

end

private

class SolutionSpaceCheckStrategySolutionMock < SolutionMock

  def init_representation
     @x_values = [0, 0, 0]
  end

  def get_solution_representation
    @x_values
  end

  def set_solution_representation(representation)
    @x_values = representation
  end
end
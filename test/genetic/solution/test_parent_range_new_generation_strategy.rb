require './abstract_test_case'
require './mock/solution_mock'
require 'gimuby/genetic/solution/new_generation_strategy/parent_range_new_generation_strategy'

class TestParentRangeNewGenerationStrategy < AbstractTestCase

  def test_reproduce
    solution1 = get_mock_solution
    solution1_representation = [1,2,3,4]
    solution1.set_solution_representation(solution1_representation)
    solution2 = get_mock_solution
    solution2_representation = [12,205,4,4]
    solution2.set_solution_representation(solution2_representation)

    solution1.new_generation_strategy = get_new_generation_strategy

    new_solution = solution1.reproduce(solution1, solution2).pop
    new_solution_representation = new_solution.get_solution_representation

    new_solution_representation.each_index do |i|
      new_value = new_solution_representation[i]
      min = solution1_representation[i]
      max = solution2_representation[i]

      assert(new_value >= min, 'New value should be superior to min')
      assert(new_value <= max, 'New value should be superior to max')
    end
  end

  def get_mock_solution
    ParentRangeNewGenerationStrategySolutionMock.new
  end

  def get_new_generation_strategy
    ParentRangeNewGenerationStrategy.new(0)
  end

end

private

class ParentRangeNewGenerationStrategySolutionMock < SolutionMock

  def init_representation
    @x_values = [12, 0]
  end

  def get_solution_representation
    @x_values
  end

  def set_solution_representation(representation)
    @x_values = representation
  end

  protected

  def check

  end
end
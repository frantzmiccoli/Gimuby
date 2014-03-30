require './abstract_test_case'
require './mock/solution_mock'
require 'gimuby/genetic/solution/new_generation_strategy/cross_over_new_generation_strategy'

class TestParentRangeNewGenerationStrategy < AbstractTestCase

  def test_reproduce
    solution1 = get_mock_solution
    solution1_representation = [1,2,3,4]
    solution1.set_solution_representation(solution1_representation)
    solution2 = get_mock_solution
    solution2_representation = [12,205,7,5]
    solution2.set_solution_representation(solution2_representation)

    solution1.new_generation_strategy = get_new_generation_strategy

    new_solutions = solution1.reproduce(solution1, solution2)
    new_solution1 = new_solutions.pop
    new_solution_representation1 = new_solution1.get_solution_representation
    new_solution_representation2 = new_solution2.get_solution_representation

    values = solution1_representation + solution2_representation

    values.each do |v|
      in_new1 = new_solution_representation1.include?(v)
      in_new2 = new_solution_representation2.include?(v)
      xor_in_new = (in_new1 || in_new2) && (!(in_new1 && in_new2))

      assert(xor_in_new, 'Each value should be present in only one representation')
    end
  end

  def get_mock_solution
    CrossOverNewGenerationStrategySolutionMock.new
  end

  def get_new_generation_strategy
    CrossOverNewGenerationStrategy.new(0)
  end

end

private

class CrossOverNewGenerationStrategySolutionMock < SolutionMock

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
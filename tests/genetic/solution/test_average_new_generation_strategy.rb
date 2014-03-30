require './mock/solution_mock'
require './abstract_test_case'
require 'gimuby/genetic/solution/new_generation_strategy/average_new_generation_strategy'

class TestAverageNewGenerationStrategy < AbstractTestCase

  def test_reproduce
    solution1 = get_mock_solution
    solution2 = get_mock_solution
    solution2 = get_mock_solution while solution2.get_fitness == solution1.get_fitness
    case solution1.get_fitness <=> solution2.get_fitness
      when -1
        best_solution = solution1
        worst_solution = solution2
      when 1
        best_solution = solution2
        worst_solution = solution1
      else
        raise 'Unexpected case'
    end

    best_solution.set_solution_representation([0.0, 0.0, 0.0])
    worst_solution.set_solution_representation([3.0, 6.0, 9.0])

    best_solution.new_generation_strategy = get_new_generation_strategy
    new_solution = best_solution.reproduce(best_solution, worst_solution).pop
    new_representation = new_solution.get_solution_representation
    assert_equal([1.0, 2.0, 3.0], new_representation,
                 'The new solution should be correctly computed')
  end

  def get_mock_solution
    AverageNewGenerationStrategySolutionMock.new
  end

  def get_new_generation_strategy
    AverageNewGenerationStrategy.new(2)
  end
end

private

class AverageNewGenerationStrategySolutionMock < SolutionMock

  def initialize(representation = nil)
    super(representation)
    @fitness = rand()
  end

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
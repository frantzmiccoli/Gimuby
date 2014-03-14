require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/solution/new_generation_strategy/combined_new_generation_strategy'
require 'gimuby/genetic/solution/new_generation_strategy/new_generation_strategy'
require './mock/solution_mock'

class TestCombinedNewGenerationStrategy < AbstractTestCase

  def test_reproduce
    mock_new_generation_strategy1 = get_mock_new_generation_strategy
    mock_new_generation_strategy2 = get_mock_new_generation_strategy
    new_generation_strategy = get_new_generation_strategy(mock_new_generation_strategy1,
                                                          mock_new_generation_strategy2)

    solution1 = get_mock_solution
    solution2 = get_mock_solution

    number_of_times = 200
    number_of_times.times do |_|
      new_generation_strategy.reproduce(solution1, solution2)
    end

    [mock_new_generation_strategy1, mock_new_generation_strategy2].each do |strategy|
      call_count = strategy.call_count
      theorical_call_count = number_of_times / 2
      delta_ratio = (call_count.to_f - theorical_call_count.to_f) / theorical_call_count.to_f
      tolerance = 0.2
      message = 'Each mock strategy should be equally called'
      assert_in_delta(0, delta_ratio, tolerance, message)
    end
  end

  def get_mock_solution
    CombinedNewGenerationStrategySolutionMock.new
  end

  def get_mock_new_generation_strategy
    CombinedNewGenerationStrategyNewGenerationStrategyMock.new
  end

  def get_new_generation_strategy(new_generation_strategy1,
                                  new_generation_strategy2)
    new_generation_strategy = CombinedNewGenerationStrategy.new
    new_generation_strategy.add_strategy(new_generation_strategy1)
    new_generation_strategy.add_strategy(new_generation_strategy2)
    new_generation_strategy
  end

end

private

class CombinedNewGenerationStrategyNewGenerationStrategyMock < NewGenerationStrategy

  def initialize
    @call_count = 0
  end

  attr_accessor :call_count

  def reproduce(solution1, solution2)
    @call_count += 1
    [solution1, solution2]
  end

end

class CombinedNewGenerationStrategySolutionMock < SolutionMock

  def init_representation
    @x_values = [0, 0]
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
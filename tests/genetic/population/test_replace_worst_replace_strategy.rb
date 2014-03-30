require './abstract_test_case'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'
require 'gimuby/genetic/population/population'
require './mock/solution_mock'


class TestReplaceWorstReplaceStrategy < AbstractTestCase

  def test_replace
    solutions = get_mock_solutions
    population = get_mock_population
    solutions.each do |solution|
      population.add_solution solution
    end
    strategy = get_strategy
    strategy.replace_proportion = 50.to_f / 100.to_f
    new_solutions = strategy.replace(population, solutions[0..1])

    should_be_missing = solutions[-2..-1] #the two last ones are the worst
    new_solutions.each do |new_solution|
      should_be_missing.each do |missing_solution|
        assert_not_equal(missing_solution.object_id, new_solution.object_id,
                         'The old and low quality solution should be missing')
      end
    end

    should_be_there = solutions[0..1]
    should_be_there.each do |solution|
      assert(new_solutions.include?(solution),
             'The best solutions should be kept')
    end

  end

  def get_mock_population
    Population.new
  end

  def get_mock_solutions
    solutions = []
    solutions.push ReplaceWorstReplaceStrategySolutionMock.new(1)
    solutions.push ReplaceWorstReplaceStrategySolutionMock.new(2)
    solutions.push ReplaceWorstReplaceStrategySolutionMock.new(3)
    solutions.push ReplaceWorstReplaceStrategySolutionMock.new(4)
    solutions
  end

  def get_strategy
    ReplaceWorstReplaceStrategy.new
  end

end


private

class ReplaceWorstReplaceStrategySolutionMock < SolutionMock
  def initialize(fitness)
    super()
    @fitness = fitness
  end

  def get_solution_representation
    [0, 0, 0, 1]
  end
end
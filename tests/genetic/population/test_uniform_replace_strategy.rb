require './abstract_test_case'
require 'gimuby/genetic/population/replace_strategy/uniform_replace_strategy'
require 'gimuby/genetic/population/population'
require './mock/solution_mock'


class TestUniformReplaceStrategy < AbstractTestCase

  def test_replace
    solutions = get_mock_solutions
    population = get_mock_population
    solutions.each do |solution|
      population.add_solution solution
    end
    strategy = get_strategy
    strategy.replace_proportion = 50.to_f / 100.to_f
    strategy.replace(population, solutions[0..1])
  end

  def get_mock_population
    Population.new
  end

  def get_mock_solutions
    solutions = []
    solutions.push UniformReplaceStrategySolutionMock.new(1)
    solutions.push UniformReplaceStrategySolutionMock.new(2)
    solutions.push UniformReplaceStrategySolutionMock.new(3)
    solutions.push UniformReplaceStrategySolutionMock.new(4)
    solutions
  end

  def get_strategy
    UniformReplaceStrategy.new
  end

end


private

class UniformReplaceStrategySolutionMock < SolutionMock
  def initialize(fitness)
    super()
    @fitness = fitness
  end

  def get_solution_representation
    [0, 0, 0, 1]
  end
end
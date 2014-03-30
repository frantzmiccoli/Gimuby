require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/population/population'
require './mock/solution_mock'

class TestBestsPickStrategy < AbstractTestCase

  def test_pick
    strategy = get_bests_pick_strategy
    population = get_mock_population
    strategy.pick_proportion = 1.to_f / 4.to_f

    picked = strategy.pick(population)
    assert_equal(1, picked.length,
                 'Only one solution should have been picked')
    assert_equal(-12, picked[0].get_fitness,
                 'Fitness should be the lowest')

    strategy.pick_proportion = 2.to_f / 4.to_f

    picked = strategy.pick(population)
    assert_equal(2, picked.length,
                 'Two solutions should have been picked')
    assert_equal(-12, picked[0].get_fitness,
                 'Fitness should be the lowest')
    assert_equal(1, picked[-1].get_fitness,
                 'Fitness should be the second lowest')

    strategy.pick_proportion = 4.to_f / 4.to_f

    picked = strategy.pick(population)
    assert_equal(4, picked.length,
                 'Four solutions should have been picked')
    assert_equal(-12, picked[0].get_fitness,
                 'Fitness should be the lowest')
    assert_equal(100, picked[-1].get_fitness,
                 'Fitness should be the highest')
  end

  protected

  def get_mock_population
    Population.new get_mock_solutions
  end

  def get_mock_solutions
    solutions = []
    solutions.push BestPickStrategySolutionMock.new(1)
    solutions.push BestPickStrategySolutionMock.new(100)
    solutions.push BestPickStrategySolutionMock.new(12)
    solutions.push BestPickStrategySolutionMock.new(-12)
    solutions
  end

  def get_bests_pick_strategy
    BestsPickStrategy.new
  end

end

private

class BestPickStrategySolutionMock < SolutionMock
  def initialize(fitness)
    super
    @fitness = fitness
  end
end
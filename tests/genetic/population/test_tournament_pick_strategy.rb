require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/population/pick_strategy/tournament_pick_strategy'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/population/population'
require './mock/solution_mock'

class TestTournamentPickStrategy < AbstractTestCase

  def test_pick
    strategy = get_tournament_pick_strategy
    population = get_mock_population
    strategy.pick_proportion = 1.to_f / 4.to_f

    picked = strategy.pick(population)
    assert_equal(1, picked.length,
                 'Only one solution should have been picked')
    assert_equal(-12, picked[0].get_fitness,
                 'Lowest fitness should be there')

    strategy.pick_proportion = 2.to_f / 4.to_f

    picked = strategy.pick(population)
    picked_fitnesses = picked.map do |s|
       s.get_fitness
    end
    assert_equal(2, picked_fitnesses.length,
                 'Two solutions should have been picked')
    assert_not_equal(nil, picked_fitnesses.index(-12),
                 'Lowest fitness should be there')

    worst_index_1 = picked_fitnesses.index(100)
    worst_index_2 = picked_fitnesses.index(12)

    assert(worst_index_1.nil? | worst_index_2.nil?,
                 'Highest fitness should not be there')
  end

  protected

  def get_mock_population
    Population.new get_mock_solutions
  end

  def get_mock_solutions
    solutions = []
    solutions.push TournamentPickStrategySolutionMock.new(1)
    solutions.push TournamentPickStrategySolutionMock.new(100)
    solutions.push TournamentPickStrategySolutionMock.new(12)
    solutions.push TournamentPickStrategySolutionMock.new(-12)
    solutions
  end

  def get_tournament_pick_strategy
    TournamentPickStrategy.new
  end

end

private

class TournamentPickStrategySolutionMock < SolutionMock
  def initialize(fitness)
    super
    @fitness = fitness
  end
end
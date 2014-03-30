require 'test/unit'
require 'gimuby/genetic/population/pick_strategy/random_wheel_pick_strategy'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/solution/solution'
require './mock/solution_mock'

class TestRandomWheelPickStrategy < AbstractTestCase

  def test_pick
    pick_strategy = get_random_wheel_pick_strategy
    population = get_mock_population
    ordered = get_ordered_by_pick_frequence(pick_strategy, population)

    assert_equal(-12, ordered[0].get_fitness(),
                 'Solutions should be ordered according to their fitness')
    assert_equal(1, ordered[1].get_fitness(),
                 'Solutions should be ordered according to their fitness')
    assert_equal(12, ordered[2].get_fitness(),
                 'Solutions should be ordered according to their fitness')
    assert_equal(100, ordered[3].get_fitness(),
                 'Solutions should be ordered according to their fitness')
  end

  protected

  # @param [PickStrategy] pick_strategy
  # @param [Array] solutions
  # @param [Array|nil] fitnesses
  # @return [Array]
  def get_ordered_by_pick_frequence(pick_strategy, population)
    solutions = population.solutions
    number_of_tries = 1000
    array_of_picked = []
    begin
      array_of_picked.push(pick_strategy.pick(population))
    end while array_of_picked.length < number_of_tries

    # We compute the score 'number of time first of the solutions'
    scores_hash = {}
    array_of_picked.each do |picked|
      solution_id = picked[0].object_id
      if scores_hash.has_key? solution_id
        scores_hash[solution_id] += 1
      else
        scores_hash[solution_id] = 0
      end
    end

    # We get the solutions ordered by their picked has first place
    # frequencies
    scores = scores_hash.values
    scores.sort!.reverse!
    ordered_solutions = []
    while scores.length > 0
      solution_id = scores_hash.index scores[0]
      scores.slice!(0)
      solutions.each do |solution|
        if solution.object_id == solution_id
          ordered_solutions.push(solution)
          break
        end
      end
    end
    ordered_solutions
  end

  def get_mock_population
    Population.new get_mock_solutions
  end

  # @return [Array]
  def get_mock_solutions
    solutions = []
    solutions.push RandomWheelPickStrategySolutionMock.new(1)
    solutions.push RandomWheelPickStrategySolutionMock.new(100)
    solutions.push RandomWheelPickStrategySolutionMock.new(12)
    solutions.push RandomWheelPickStrategySolutionMock.new(-12)
    solutions
  end

  # @return [PickStrategy]
  def get_random_wheel_pick_strategy
    RandomWheelPickStrategy.new
  end
end

private

class RandomWheelPickStrategySolutionMock < SolutionMock
  def initialize(fitness)
    super()
    @fitness = fitness
  end
end
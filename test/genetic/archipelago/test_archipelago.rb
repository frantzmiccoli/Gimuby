require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/fully_connected_connect_strategy'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/archipelago/archipelago'
require './mock/solution_mock'

class TestArchipelago < AbstractTestCase

  def initialize(test_method_name)
    super(test_method_name)
    @migration_count = 0
  end

  def test_generation_step
    archipelago = get_archipelago
    fitness_sum1 = 0
    solutions_count1 = 0
    archipelago.populations.each do |population|
      population.solutions.each do |solution|
        fitness_sum1 += solution.get_fitness
        solutions_count1 += 1
      end
    end
    populations_count1 = archipelago.populations.length

    archipelago.migration_rate = (50.0 / 100.0)
    10.times do |_|
      archipelago.generation_step
    end

    fitness_sum2 = 0
    solutions_count2 = 0
    archipelago.populations.each do |population|
      population.solutions.each do |solution|
        fitness_sum2 += solution.get_fitness
        solutions_count2 += 1
      end
    end
    populations_count2 = archipelago.populations.length

    assert(populations_count1 == populations_count2,
           'Solutions count shouldn\'t have change.')

    assert(solutions_count1 == solutions_count2,
           'Solutions count shouldn\'t have change.')

    message = 'Fitness should decrease between generation, this ensure that migration scheme is working'
    assert(fitness_sum2 < fitness_sum1,
           message)
  end

  def test_migration_type
    @migration_count = 0
    $dependencies.event_manager.register_listener :on_archipelago_migration_begin  do |e|
      self.on_migration(e)
    end

    archipelago = get_archipelago
    migration_period = 100.0
    archipelago.migration_type = :fixed_time
    archipelago.migration_rate = 1.0 / migration_period
    (migration_period - 1).to_i.times do |_|
      archipelago.generation_step
    end
    self.assert_equal(0, @migration_count)
    archipelago.generation_step
    self.assert_not_equal(0, @migration_count)

    @migration_count = 0
    archipelago = get_archipelago
    migration_period = 100
    archipelago.migration_type = :random
    archipelago.migration_rate = 1.0 / migration_period
    (migration_period - 1).to_i.times do |_|
      archipelago.generation_step
    end
    # this should trigger a couple migrations
    self.assert_not_equal(0, @migration_count)
  end

  def on_migration(e)
    @migration_count += 1
  end

  protected

  def get_archipelago
    archipelago = Archipelago.new
    archipelago.connect_strategy = get_mock_connect_strategy
    10.times do |i|
      archipelago.add_population(get_mock_population(i))
    end
    archipelago.connect_all
    archipelago
  end

  def get_mock_connect_strategy
    FullyConnectedConnectStrategy.new
  end

  def get_mock_population(value)
    solutions = get_mock_solutions(value)
    population = Population.new
    solutions.each do |solution|
      population.add_solution solution
    end
    population.pick_strategy = get_mock_pick_strategy
    population.pick_strategy.pick_proportion = 50.to_f / 100.to_f
    population.replace_strategy = get_mock_replace_strategy
    population
  end

  def get_mock_pick_strategy
    BestsPickStrategy.new
  end

  def get_mock_replace_strategy
    strategy = ReplaceWorstReplaceStrategy.new
    strategy.replace_proportion = 50.to_f / 100.to_f
    strategy
  end

  def get_mock_solutions(value)
    solutions = []
    solutions.push ArchipelagoSolutionMock.new(value)
    solutions.push ArchipelagoSolutionMock.new(value)
    solutions.push ArchipelagoSolutionMock.new(value)
    solutions.push ArchipelagoSolutionMock.new(value)
    solutions
  end

end

private

class ArchipelagoSolutionMock < SolutionMock
  def reproduce(sol1, sol2)
    [sol1.clone, sol2.clone]
  end

  def initialize(fitness)
    super()
    @fitness = fitness
  end

  def mutate

  end
end
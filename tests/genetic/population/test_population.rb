require './abstract_test_case'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy.rb'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy.rb'
require 'gimuby/genetic/solution/solution'
require 'gimuby/genetic/population/population'
require './mock/solution_mock'


class TestPopulation < AbstractTestCase

  def test_generation_step
    population = get_population
    fitness_sum1 = 0
    solutions_count1 = 0
    population.solutions.each do |solution|
      fitness_sum1 += solution.get_fitness
      solutions_count1 += 1
    end
    population.generation_step
    fitness_sum2 = 0
    solutions_count2 = 0
    population.solutions.each do |solution|
      fitness_sum2 += solution.get_fitness
      solutions_count2 += 1
    end

    assert(solutions_count1 == solutions_count2,
          'Solutions count shouldn\'t have changed')

    assert(fitness_sum2 < fitness_sum1,
           'Fitness should decrease between generation')
  end

  def get_population
    solutions = get_mock_solutions
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

  def get_mock_solutions
    solutions = []
    solutions.push CurrentSolutionMock.new(1)
    solutions.push CurrentSolutionMock.new(2)
    solutions.push CurrentSolutionMock.new(3)
    solutions.push CurrentSolutionMock.new(4)
    solutions
  end
end

private

class CurrentSolutionMock < SolutionMock
  def reproduce(sol1, sol2)
    [sol1.clone, sol2.clone]
  end

  def initialize(fitness)
    super()
    @fitness = fitness
  end
end
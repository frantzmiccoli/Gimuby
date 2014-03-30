require './abstract_test_case'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'

class AbstractTestProblemSolution < AbstractTestCase

  def test_generation_step
    if self.class == AbstractTestProblemSolution
      return
    end

    population = get_population
    old_best_fitness = population.get_best_fitness
    20.times do |_|
      population.generation_step
    end
    new_best_fitness = population.get_best_fitness

    message = 'Best fitness should have decrease'
    assert(new_best_fitness < old_best_fitness, message)
  end

  def get_solution
    raise NotImplementedError
  end

  def get_population
    population = Population.new
    population.pick_strategy = BestsPickStrategy.new
    population.replace_strategy = ReplaceWorstReplaceStrategy.new

    30.times do |_|
      population.add_solution(get_solution)
    end

    population
  end

end
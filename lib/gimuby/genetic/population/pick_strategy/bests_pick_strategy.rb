require 'gimuby/genetic/population/pick_strategy/pick_strategy'

class BestsPickStrategy < PickStrategy

  def pick(population)
    solutions = population.solutions
    number = get_number_to_pick(population)
    candidates = solutions.clone

    candidates.sort! do |x, y|
      (population.get_fitness x) <=> (population.get_fitness y)
    end

    candidates.slice(0, number)
  end

end
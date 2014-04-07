require 'gimuby/genetic/population/pick_strategy/pick_strategy'

class TournamentPickStrategy < PickStrategy

  def pick(population)
    solutions = population.solutions
    number = get_number_to_pick(population)
    candidates = solutions.clone

    while candidates.length > number
      sol1 = Factory.random_entry(candidates)
      sol2 = sol1
      while sol1 == sol2
        sol2 = Factory.random_entry(candidates)
      end
      if population.get_fitness(sol1) < population.get_fitness(sol2)
        candidates.delete(sol2)
      else
        candidates.delete(sol1)
      end
    end

    candidates
  end

end

require 'gimuby/genetic/population/replace_strategy/replace_strategy'

class ReplaceWorstReplaceStrategy < ReplaceStrategy

  def initialize
    @replace_proportion = 50.to_f / 100.to_f
  end

  attr_accessor :replace_proportion

  def replace(population, selected = nil)
    solutions = population.solutions.clone

    wished_length = solutions.length
    solutions.sort! do |x, y|
      x_fitness = population.get_fitness(x)
      y_fitness = population.get_fitness(y)
      x_fitness <=> y_fitness
    end
    if selected.nil?
      selected = population.pick
    end
    number_to_remove = (wished_length * @replace_proportion).floor
    if number_to_remove == wished_length
      number_to_remove -= 1
    end
    solutions.slice!(-number_to_remove, number_to_remove)

    while solutions.length < wished_length
      begin
        random_index1 = rand(selected.length)
        random_index2 = rand(selected.length)
      end while ((random_index1 == random_index2) && (selected.length != 1))
      new_solutions = reproduce(selected[random_index1],
                                selected[random_index2])
      new_solutions.each do |new_solution|
        solutions.push(new_solution)
      end
    end

    solutions.slice!(wished_length) # we could have one that should be dropped
    solutions
  end

  protected

  def reproduce(solution1, solution2)
    solution1.reproduce(solution1, solution2)
  end


end
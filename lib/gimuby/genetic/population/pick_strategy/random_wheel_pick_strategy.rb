require 'gimuby/genetic/population/pick_strategy/pick_strategy'

class RandomWheelPickStrategy < PickStrategy

  def initialize
    super
    @random_wheel_probability_reason = 0.7
  end

  attr_accessor :random_wheel_probability_reason

  def pick(population)
    number = get_number_to_pick(population)
    reason = @random_wheel_probability_reason
    solutions = population.solutions
    candidates = solutions.clone
    candidates.sort! do |x, y|
      (population.get_fitness x) <=> (population.get_fitness y)
    end
    picked = []
    begin
      # we use a geometric sequence
      max_of_the_rand = (1 - reason ** candidates.length) / (1 - reason)
      r = rand() * max_of_the_rand
      element = 1
      candidates.each do |solution|
        max_accepted_value = (1 - reason ** element) / (1 - reason)
        element += 1
        if max_accepted_value > r
          picked.push solution
          ind = candidates.index solution
          candidates.slice! ind
          break
        end
      end
    end while picked.length < number
    picked
  end

end
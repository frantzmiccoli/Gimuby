
class PickStrategy

  def initialize
    @pick_proportion ||= 25.to_f / 100.to_f
  end

  attr_accessor :pick_proportion

  # pick some solution inside the population
  def pick(population)
    raise NotImplementedError
  end

  protected

  def get_number_to_pick(population)
    number = population.solutions.length * @pick_proportion
    number.round
  end
end
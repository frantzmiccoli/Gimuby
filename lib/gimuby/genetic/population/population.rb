require 'gimuby/dependencies'
require 'gimuby/genetic/population/pick_strategy/random_wheel_pick_strategy'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'

class Population

  def initialize(solutions = nil)
    if solutions.nil?
      @solutions = []
    else
      @solutions = solutions
    end
    @pick_strategy ||= RandomWheelPickStrategy.new
    @replace_strategy ||= ReplaceWorstReplaceStrategy.new

    trigger(:on_population_init)
  end

  attr_reader :solutions
  attr_accessor :pick_strategy
  attr_accessor :selection_rate
  attr_accessor :replace_strategy

  # Run a step of genetic algorithm: reproduction + mutation
  def generation_step
    reproduce
    @solutions.each do |solution|
      solution.mutate
    end
    trigger(:on_population_generation_step)
  end

  # Replace part of the population (used by {Archipelago})
  # @internal
  def replace(solutions)
    @solutions = @replace_strategy.replace(self, solutions)
  end

  # Simply pick some solutions and make them reproduce
  # @internal
  def reproduce
    @solutions = @replace_strategy.replace(self)
  end

  # Pick some solutions
  # @internal
  def pick
    @pick_strategy.pick(self)
  end

  # Add a solution
  # @param solution [Solution]
  def add_solution(solution)
    @solutions.push solution
  end

  def get_population_size
    @solutions.size
  end

  # Can be overridden
  def get_fitness(solution)
    solution.get_fitness
  end

  def get_average_fitness
    sum = 0
    @solutions.each do |solution|
      sum += solution.get_fitness
    end
    # Beware of that division by 0
    sum / @solutions.length
  end

  def get_best_fitness
    best_solution = get_best_solution
    best_solution.get_fitness
  end

  def get_best_solution
    @solutions.min_by do |solution|
      solution.get_fitness
    end
  end

  protected

  def trigger(event_type)
    event_data = {:population => self}
    get_event_manager.trigger_event(event_type, event_data)
  end

  def get_event_manager
    $dependencies.event_manager
  end
end
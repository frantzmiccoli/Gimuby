require 'gimuby/dependencies'
require 'gimuby/config'
require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy'
require 'gimuby/genetic/population/pick_strategy/random_wheel_pick_strategy'
require 'gimuby/genetic/population/pick_strategy/tournament_pick_strategy'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'
require 'gimuby/genetic/population/replace_strategy/uniform_replace_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/circle_connect_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/fully_connected_connect_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/random_connect_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/constant_degree_connect_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/barabasi_albert_connect_strategy'
require 'gimuby/genetic/archipelago/connect_strategy/watts_strogatz_connect_strategy'
require 'gimuby/problem/tsp/tsp_solution'
require 'gimuby/problem/rastrigin/rastrigin_solution'
require 'gimuby/problem/lennard_jones/lennard_jones_solution'
require 'gimuby/problem/schaffer/schaffer_solution'
require 'gimuby/problem/rosenbrock/rosenbrock_solution'
require 'gimuby/problem/step/step_solution'
require 'gimuby/problem/sphere/sphere_solution'
require 'gimuby/problem/foxholes/foxholes_solution'

class Factory

  def initialize
    @optimal_population = FALSE
    @optimal_archipelago = FALSE

    # use for test purpose to avoid provided archipelago to be connected
    @connected_archipelago = TRUE

    # those values are set by the user, let them nil and we won't use them
    @solutions_number = nil
    @populations_number = nil

    # if we have to generate values we store them here
    @_solutions_number = nil
    @_populations_number = nil
  end

  attr_accessor :optimal_population
  attr_accessor :optimal_archipelago

  attr_accessor :connected_archipelago

  attr_accessor :solutions_number
  attr_accessor :populations_number

  def reset_state
    @connected_archipelago = TRUE
    @_populations_number = nil
    @_solutions_number = nil
  end

  def get_population(&solution_generator)
    _get_population(:population, &solution_generator)
  end

  def get_archipelago(&solution_generator)
    if @optimal_archipelago
      return get_optimal_archipelago(&solution_generator)
    end
    get_random_archipelago(&solution_generator)
  end

  def get_optimal_population(optimizer, &solution_generator)
    candidate_population = get_random_population(optimizer, &solution_generator)
    begin
      candidate_population = get_random_population(optimizer, &solution_generator)
      if candidate_population.solutions.length >= 1000
        next
      end
      if candidate_population.solutions[0].mutation_strategy.mutation_rate >= 0.1
        next
      end
      if candidate_population.replace_strategy.replace_proportion <= 0.4
        next
      end
      if candidate_population.pick_strategy.pick_proportion >= 0.4
        next
      end
    end while FALSE
    candidate_population
  end

  def get_optimal_archipelago(&solution_generator)
    is_optimal = FALSE
    begin
      candidate_archipelago = get_random_archipelago(&solution_generator)
      is_optimal = TRUE
      if (candidate_archipelago.get_population_size <= 500) or
          (candidate_archipelago.get_population_size >= 1100)
        is_optimal = FALSE
      end
      if candidate_archipelago.migration_rate <= 0.25
        is_optimal = FALSE
      end
      if (candidate_archipelago.populations.length < 10) or
          (candidate_archipelago.populations.length > 29)
        is_optimal = FALSE
      end
      if candidate_archipelago.get_diameter >= 100
        is_optimal = FALSE
      end
    end until is_optimal
    candidate_archipelago
  end

  def get_random_population(optimizer, &solution_generator)
    population = Population.new
    population.pick_strategy = get_random_pick_strategy
    population.replace_strategy = get_random_replace_strategy
    populations_number = get_populations_number
    unless optimizer == :archipelago
      populations_number = 1
    end
    solutions_number = get_solutions_number(populations_number)
    number_solutions_per_population = solutions_number / populations_number
    mutation_rate = rand * 0.7
    number_solutions_per_population.times do
      solution = solution_generator.call
      solution.mutation_strategy.mutation_rate = mutation_rate
      population.add_solution(solution)
    end

    population
  end

  def get_random_archipelago(&solution_generator)
    archipelago = Archipelago.new
    archipelago.connect_strategy = get_random_connect_strategy
    # between 0.01% and ~35%
    archipelago.migration_rate = (rand() * 35.0 / 100.0) + 0.0001
    archipelago.migration_symmetric = [true, false].choice
    archipelago.migration_type = [:random, :synchronized, :fixed_time].choice
    get_populations_number.times do |_|
      archipelago.add_population(_get_population(:archipelago, &solution_generator))
    end
    if @connected_archipelago
      archipelago.connect_all
    end
    archipelago
  end

  protected

  def _get_population(optimizer, &solution_generator)
    if @optimal_population
      return get_optimal_population(optimizer, &solution_generator)
    end
    get_random_population(optimizer, &solution_generator)
  end

  def get_solutions_number(populations_number = 1)
    unless @_solutions_number.nil?
      return @_solutions_number
    end
    unless @solutions_number.nil?
      return @solutions_number
    end

    max_population_size = 5000
    min_population_size = 12 * populations_number
    if @optimal_population
      max_population_size = 1000
    end
    if @optimal_archipelago
      min_population_size = 500
      max_population_size = [max_population_size, 1100].min
    end

    solutions_number_range = *(min_population_size..max_population_size)
    picked_solutions_number = 0
    solutions_per_population = 0
    min_solutions_per_population = min_population_size / populations_number
    begin
      picked_solutions_number = solutions_number_range.choice
      picked_solutions_number /= populations_number
      picked_solutions_number *= populations_number
      solutions_per_population = picked_solutions_number / populations_number
    end while solutions_per_population < min_solutions_per_population

    @_solutions_number = picked_solutions_number
    @_solutions_number
  end

  def get_populations_number
    unless @_populations_number.nil?
      return @_populations_number
    end
    unless @populations_number.nil?
      @_populations_number = @populations_number
      return @_populations_number
    end

    populations_number_range = *(2..100)
    if @optimal_archipelago
      populations_number_range = *(10..29)
    end

    @_populations_number = populations_number_range.choice
    @_populations_number
  end

  def get_random_pick_strategy
    max = 10
    r = rand(max)
    if r == 0
      return BestsPickStrategy.new
    elsif r == 1
      return TournamentPickStrategy.new
    end
    r = rand(9) + 1
    strategy = RandomWheelPickStrategy.new
    reason = 1.0 / 10.0 * r
    strategy.random_wheel_probability_reason = reason

    # pick proportion
    min = 0.1
    max = 0.9
    spread = max - min
    strategy.pick_proportion = (rand() * spread) + min

    strategy
  end

  def get_random_replace_strategy
    if rand() < 0.2
      strategy = UniformReplaceStrategy.new
    else
      strategy = ReplaceWorstReplaceStrategy.new
    end

    # replace proportion
    min = 0.05
    max = 1.0
    spread = max - min
    replace_proportion = (rand() * spread) + min
    strategy.replace_proportion = replace_proportion
    strategy
  end

  def get_random_connect_strategy
    r = rand(10)
    if r == 0
      return CircleConnectStrategy.new
    end
    if r == 1
      return FullyConnectedConnectStrategy.new
    end
    r = rand(4)
    max_degree = [22, get_populations_number - 1].min
    # even number means easier by two divisions
    average_degree = (rand((max_degree - 1)/ 2) + 1) * 2
    # avoid a bug on an edge case when max_degree = 2
    average_degree = [average_degree, max_degree].min
    case r
      when 0
        strategy = RandomConnectStrategy.new
      when 1
        strategy = ConstantDegreeConnectStrategy.new
      when 2
        strategy = BarabasiAlbertConnectStrategy.new
      when 3
        strategy = WattsStrogatzConnectStrategy.new
      else
        raise 'random value (r) has an unexpected value'
    end
    strategy.average_degree = average_degree
    strategy
  end

end
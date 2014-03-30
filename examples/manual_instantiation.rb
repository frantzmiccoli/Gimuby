require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/archipelago/connect_strategy/fully_connected_connect_strategy'

require 'gimuby/genetic/population/population'
require 'gimuby/genetic/population/pick_strategy/tournament_pick_strategy'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'

require 'gimuby/problem/step/step_solution'

# Manual archipelago creation
archipelago = Archipelago.new
archipelago.connect_strategy = FullyConnectedConnectStrategy.new
archipelago.migration_rate = 10.0 / 100.0
archipelago.migration_symmetric = true
archipelago.migration_type = :synchronized

10.times do
  # Manual population creation
  population = Population.new
  population.pick_strategy = TournamentPickStrategy.new
  population.replace_strategy = ReplaceWorstReplaceStrategy.new

  # We add solution of the relevant problem
  30.times do
    solution = StepSolution.new
    population.add_solution(solution)
  end

  # The current population is attached to the archipelago
  archipelago.add_population(population)
end

# Every population is here, we connect them together
archipelago.connect_all

# We run the algorithm
100.times do
  archipelago.generation_step
end

puts archipelago.get_best_fitness
require 'gimuby'
require 'gimuby/problem/step/step_solution'
require 'time'

SolutionClass = StepSolution

srand(ARGV[0].to_i)
puts ARGV[0]

# Let's test the following configurations, the optimizer is either population
# for a standard genetic algorithm, either archipelago for a "distributed"
# version of the algorithm (nothing is distributed in Gimuby)
configs = [
    {
        :optimizer => :population,
        :optimal_archipelago => FALSE,
        :optimal_population => FALSE
    },
    {
        :optimizer => :archipelago,
        :optimal_archipelago => FALSE,
        :optimal_population => FALSE
    },
    {
        :optimizer => :population,
        :optimal_archipelago => FALSE,
        :optimal_population => TRUE
    },
    {
        :optimizer => :archipelago,
        :optimal_archipelago => TRUE,
        :optimal_population => FALSE
    },
    {
        :optimizer => :archipelago,
        :optimal_archipelago => TRUE,
        :optimal_population => TRUE
    }
]

configs.each do |config_hash|
  puts '----------------'
  factory = Gimuby::get_factory
  factory.optimal_population = config_hash[:optimal_population]
  factory.optimal_archipelago = config_hash[:optimal_archipelago]

  t0 = Time.new
  if config_hash[:optimizer] == :population
    optimizer = factory.get_population {next SolutionClass.new}
  elsif config_hash[:optimizer] == :archipelago
    optimizer = factory.get_archipelago {next SolutionClass.new}
  else
    raise Exception.new('Nothing to do here')
  end

  current_best_fitness = optimizer.get_best_fitness
  initial_best_fitness = current_best_fitness
  100.times do |iteration|
    optimizer.generation_step
    current_best_fitness = optimizer.get_best_fitness

    # We know by construction that this problem optimal solution's fitness is
    # -25, REMOVE THESE LINES if you change SolutionClass to something else
    if current_best_fitness == -25
      puts 'optimal solution reached at iteration ' + iteration.to_s
      break
    end
  end
  final_best_fitness = current_best_fitness
  t1 = Time.new
  t_diff = t1 - t0

  puts config_hash[:optimizer].to_s +
           ' (optimal population = ' + factory.optimal_population.to_s +
           ', optimal archipelago = ' + factory.optimal_archipelago.to_s +
           ')' + ' (' + t_diff.to_s + ' s) : ' +
           initial_best_fitness.to_s + ' --> ' + final_best_fitness.to_s
  puts '----------------'
end
puts '----------------'
require 'gimuby/dependencies'
require 'gimuby/genetic/archipelago/connect_strategy/random_connect_strategy'
require 'gimuby/genetic/archipelago/measure/clustering_coefficient_measure'
require 'gimuby/genetic/archipelago/measure/diameter_measure'
require 'gimuby/genetic/archipelago/measure/connected_measure'

class Archipelago

  def initialize
    @populations = [] # each population is an island
    @connections = {} # an hash of array containing indexes pointing population,
                      # (sparse adjacency matrix)
    @connect_strategy = RandomConnectStrategy.new
    @migration_rate = (1.0/100.0)
    @migration_type = :random # use also :synchronized or :fixed_time
    @migration_symmetric = FALSE

    @generation_step_count = 0 #internal usage
    @populations_to_migrate_indexes = []

    reset_topological_metrics

    trigger(:on_archipelago_init)
  end

  attr_accessor :populations
  attr_accessor :connections
  attr_accessor :connect_strategy
  attr_accessor :migration_rate
  attr_accessor :migration_type
  attr_accessor :migration_symmetric

  # Trigger a generation step on each subpopulation
  def generation_step
    reset_populations_migration_state
    @generation_step_count += 1
    archipelago_level_migration = FALSE
    if @migration_type == :synchronized
      archipelago_level_migration = rand() < @migration_rate
    end
    if @migration_type == :fixed_time
      archipelago_level_migration = should_fixed_time_migrate
    end
    @populations.each do |population|
      population.generation_step
      migrate(population, archipelago_level_migration)
    end
    trigger(:on_archipelago_generation_step)
  end

  def add_population population
    @populations.push population
    reset_topological_metrics
  end

  # Connect the different populations of the archipelago
  def connect_all
    @connect_strategy.connect(self)
  end

  def get_population_size
    size = 0
    @populations.each do |population|
      size += population.get_population_size
    end
    size
  end

  def get_size
    @populations.size
  end

  def get_connected_classes_count
    ConnectedMeasure.new.compute(self)
  end

  def get_diameter
    DiameterMeasure.new.compute(self)
  end

  def get_clustering_coefficient
    unless @clustering_coefficient.nil?
      return @clustering_coefficient
    end
    @clustering_coefficient = ClusteringCoefficientMeasure.new.compute(self)
  end

  # @internal
  def get_nodes
    nodes = *(0..@populations.length - 1)
    nodes
  end

  # @internal
  def get_neighbors(node)
    unless @connections.has_key?(node)
      return []
    end
    @connections[node].clone
  end

  # Connect two population from their index in the list
  # @internal
  def connect(population_index1, population_index2)
    if population_index1 == population_index2
      return
    end
    add_edge(population_index1, population_index2)
    add_edge(population_index2, population_index1)
    reset_topological_metrics
  end

  # Create a connection from a population to another
  def add_edge(population_index1, population_index2)
    if population_index1 == population_index2
      return
    end
    unless @connections.has_key? population_index1
      @connections[population_index1] = []
    end
    unless @connections[population_index1].include? population_index2
      @connections[population_index1].push(population_index2)
    end
  end

  # Remove a connection
  def remove_edge(population_index1, population_index2)
    if @connections.has_key? population_index1
      @connections[population_index1].delete(population_index2)
    end
    if @connections.has_key? population_index2
      @connections[population_index2].delete(population_index1)
    end
  end

  def has_edge(population_index1, population_index2)
    unless @connections.has_key? population_index1
      return FALSE
    end
    @connections[population_index1].include? population_index2
  end

  def get_edges
    edges = []
    @connections.each do |node, facing_nodes|
      facing_nodes.each do |facing_node|
        edges.push([node, facing_node])
      end
    end
    edges
  end

  def get_edges_count
    edges_count = 0
    @connections.values.each do |target_connections|
      target_connections_length = target_connections.length
      edges_count += target_connections_length
    end
    edges_count
  end

  def get_average_degree
    nodes_count = @populations.length.to_f
    edges_count = get_edges_count.to_f
    edges_count / nodes_count
  end

  def get_average_fitness
    sum = 0
    @populations.each do |population|
      sum += population.get_average_fitness
    end
    # Beware of that division by 0
    sum / @populations.length
  end

  def get_best_fitness
    best_solution = get_best_solution
    best_solution.get_fitness
  end

  def get_best_solution
    best_population = @populations.min_by do |population|
      population.get_best_fitness
    end
    best_population.get_best_solution
  end

  # @internal
  def connect_path(path, closed_path = FALSE)
    previous = nil
    previous = path[-1] if closed_path
    path.each do |current|
      connect(previous, current) unless previous.nil?
      previous = current
    end
  end

  # @internal
  def get_degree(node)
    unless @connections.has_key?(node)
      return 0
    end
    @connections[node].length
  end

  protected

  def migrate(population, forced = FALSE)
    if (not forced) && (@migration_type != :random)
      return FALSE
    end
    unless forced
      r = rand()
      unless (r <= @migration_rate)
        return FALSE
      end
    end
    if is_population_migrated(population)
      # the population has already been migrated, we avoid to do it twice
      return FALSE
    end
    population_index = @populations.index(population)
    unless @connections.has_key?(population_index)
      return FALSE
    end
    connected_populations_indexes = @connections[population_index]
    if connected_populations_indexes.length == 0
      return FALSE
    end
    random_index = rand(connected_populations_indexes.length + 1) - 1 # +1 -1 to avoid strange suspected behavior on rand(1)
    target_population_index = connected_populations_indexes[random_index]
    if target_population_index.nil? # Why handling that case ? No idea,
                                    # a bug occurred randomly
      return FALSE
    end
    target_population = @populations[target_population_index]
    migrate_from_to(population, target_population)
    TRUE
  end

  def migrate_from_to(population, target_population)
    selected_solutions_1 = population.pick
    to_migrate_count = selected_solutions_1.length
    selected_solutions_2 = nil
    if @migration_symmetric
      selected_solutions_2 = target_population.pick
      to_migrate_count += selected_solutions_2.length
    end
    trigger(:on_archipelago_migration_begin,
            {:migrated_solutions_count => to_migrate_count})
    target_population.replace(selected_solutions_1)
    mark_population_as_migrated(population)
    unless selected_solutions_2.nil?
      population.replace(selected_solutions_2)
      mark_population_as_migrated(target_population)
    end
    trigger(:on_archipelago_migration_end,
            {:migrated_solutions_count => to_migrate_count})
  end

  def reset_topological_metrics
    @clustering_coefficient = nil
  end

  def reset_populations_migration_state
    @populations_to_migrate = get_nodes
  end

  def mark_population_as_migrated(population)
    population_index = @populations.index(population)
    @populations_to_migrate_indexes.delete(population_index)
  end

  # @return [Boolean]
  def is_population_migrated(population)
    population_index = @populations.index(population)
    # If population is migrated it's not anymore in the list
    @populations_to_migrate.index(population_index).nil?
  end

  def should_fixed_time_migrate
    migration_period = get_migration_period
    if migration_period.nil?
      return FALSE
    end
    (@generation_step_count % get_migration_period).round == 0
  end

  def get_migration_period
    if @migration_rate == 0
      return FALSE
    end
    1.0 / @migration_rate
  end

  def trigger(event_type, event_data = {})
    event_data[:archipelago] = self
    get_event_manager.trigger_event(event_type, event_data)
  end

  def get_event_manager
    $dependencies.event_manager
  end
end
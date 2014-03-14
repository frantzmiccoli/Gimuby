
# Please note that the default are important to let unit test run perfectly
class GimubyConfig

  def initialize
    @persistence_dir_path = '/tmp'

    # Problem specific configuration

    # TSP
    @tsp_number_points = 100

    # Rastrigin
    @rastrigin_dimension = 20

    # Lennard Jones
    @lennard_jones_atoms = 31
  end

  attr_accessor :persistence_dir_path

  attr_accessor :problem

  # TSP
  attr_accessor :tsp_number_points

  # Rastrigin
  attr_accessor :rastrigin_dimension

  # Lennard Jones
  attr_accessor :lennard_jones_atoms

  attr_accessor :optimal_population
  attr_accessor :optimal_archipelago

end

$config = GimubyConfig.new()


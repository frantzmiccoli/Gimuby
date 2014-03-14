require 'gimuby/config'
require 'gimuby/problem/lennard_jones/lennard_jones'
require 'gimuby/genetic/solution/solution'

class LennardJonesSolution < Solution

  @@positions_dimensions = 3
  @@position_dimension_min = -3.0
  @@position_dimension_max = 3.0

  def initialize(atoms_positions = nil)
    super(atoms_positions)

    @check_strategy = SolutionSpaceCheckStrategy.new
    @check_strategy.set_min(@@position_dimension_min)
    @check_strategy.set_max(@@position_dimension_max)

    @new_generation_strategy = CombinedNewGenerationStrategy.new
    @new_generation_strategy.add_strategy(ParentRangeNewGenerationStrategy.new)
    @new_generation_strategy.add_strategy(CrossOverNewGenerationStrategy.new)

    @mutation_strategy = SolutionSpaceMutationStrategy.new
    @mutation_strategy.set_min(@@position_dimension_min)
    @mutation_strategy.set_max(@@position_dimension_max)
  end

  def evaluate
    get_lennard_jones.evaluate(get_solution_representation)
  end

  def get_solution_representation
    @atoms_positions.clone
  end

  def set_solution_representation(atoms_positions)
    @atoms_positions = atoms_positions.clone
    #@atoms_positions = @atoms_positions.sort_by do |atom_position|
    #  atom_position[0]
    #end
  end

  protected

  def init_representation
    @atoms_positions = []
    atoms_number = $config.lennard_jones_atoms
    atoms_number.times do
      atom_position = []
      @@positions_dimensions.times do
        position_dimension_range = (@@position_dimension_max - @@position_dimension_min)
        position_dimension = (rand * position_dimension_range) + @@position_dimension_min
        atom_position.push(position_dimension)
      end
      @atoms_positions.push(atom_position)
    end
  end

  def get_lennard_jones
    LennardJones.new
  end

end
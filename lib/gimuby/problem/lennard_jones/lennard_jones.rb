

class LennardJones

  def initialize
    @sigma = 1
  end

  # @param atoms_positions {Array}
  def evaluate(atoms_positions)
    number = atoms_positions.length
    potential = 0.0
    (number - 1).times do |i|
      atom_position_i = atoms_positions[i]
      target_indices = *(i+1..number-1)
      target_indices = [target_indices] unless target_indices.class == Array
      target_indices.each do |j|
        atom_position_j = atoms_positions[j]
        distance = get_euclidian_distance(atom_position_i, atom_position_j)
        if distance != 0
          potential += (@sigma / distance) ** 12
          potential -= (@sigma / distance) ** 6
        end
      end
    end
    potential * 4
  end

  protected

  def get_euclidian_distance(atom_position1, atom_position2)
    distance = 0.0
    atom_position1.each_index do |k|
      distance += (atom_position1[k] - atom_position2[k]) ** 2
    end
    Math.sqrt(distance)
  end
end
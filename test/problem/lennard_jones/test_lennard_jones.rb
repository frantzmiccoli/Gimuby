require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/lennard_jones/lennard_jones'

class TestLennardJones < AbstractTestCase

  def test_get_euclidian_distance
    atom_position_1 = [0.0, 0.0]
    atom_position_2 = [1.0, 1.0]

    lennard_jones = LennardJones.new
    distance = lennard_jones.send(:get_euclidian_distance, *[atom_position_1, atom_position_2])
    sqrt2 = Math.sqrt(2)
    sigma = 0.001

    self.assert((distance - sqrt2).abs < sigma, 'Distance should be correct.')
  end

end
require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/tsp/tsp'

class TestTSP < AbstractTestCase

  def test_get_permutation_distance
    tsp = get_TSP
    path = *(0..tsp.get_number_of_points - 1)
    path.shuffle
    incomplete_path = path.clone
    missing = incomplete_path.slice!(0)
    expected_delta = tsp.get_distance(incomplete_path[-1], missing)
    expected_delta += tsp.get_distance(missing, incomplete_path[0])
    expected_delta -= tsp.get_distance(incomplete_path[-1],
                                      incomplete_path[0])

    actual_delta = tsp.get_permutation_distance(path) -
                      tsp.get_permutation_distance(incomplete_path)

    assert_equal(expected_delta.abs, actual_delta.abs,
                 'The deltas should match')
  end

  # @return [Tsp]
  def get_TSP
    $dependencies.tsp
  end

end



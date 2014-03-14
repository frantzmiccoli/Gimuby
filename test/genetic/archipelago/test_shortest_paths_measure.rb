require './abstract_test_case'
require './mock/population_mock'
require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/archipelago/measure/shortest_paths_measure'

class TestShortestPathsMeasure < AbstractTestCase

  def test_compute
    size = 10
    archipelago = get_archipelago(size)
    measure = get_shortest_paths_measure

    message = 'No connected nodes, no shortest path length'
    assert_equal(0, measure.compute(archipelago).length, message)

    archipelago.connect(0, 1)
    values = measure.compute(archipelago)
    message = 'Two connected nodes, only value : 1'
    assert_equal(1, values.length, message)
    assert_equal(1, values.pop, message)

    archipelago.connect(2, 1)
    length = measure.send(:get_shortest_path_length, archipelago, 0, 2)
    message = 'Expected length is two'
    assert_equal(2, length, message)

    values = measure.compute(archipelago)
    message = 'Three connected nodes, values: 1, 1, 2'
    assert(values.include?(1), message)
    assert(values.include?(2), message)
    assert_equal(false, values.include?(3), message)
    assert_equal(false, values.include?(0), message)

    archipelago.connect(4, 5)
    values = measure.compute(archipelago)
    message = 'Three connections (two classes), values: 1, 1, 2, 1'
    assert(values.include?(1), message)
    assert(values.include?(2), message)
    assert_equal(false, values.include?(3), message)
    assert_equal(false, values.include?(0), message)
  end

  def get_archipelago(size)
    archipelago = Archipelago.new
    size.times do |_|
      archipelago.add_population(get_mock_population)
    end
    archipelago
  end

  def get_shortest_paths_measure
    ShortestPathsMeasure.new
  end

  def get_mock_population
    PopulationMock.new
  end

end

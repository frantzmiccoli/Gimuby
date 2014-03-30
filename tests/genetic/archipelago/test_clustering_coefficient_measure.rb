require './abstract_test_case'
require './mock/population_mock'
require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/archipelago/measure/clustering_coefficient_measure'

class TestClusteringCoefficientMeasure < AbstractTestCase

  def test_compute
    size = 10
    archipelago = get_archipelago(size)
    measure = get_clustering_coefficient_measure

    message = 'No connection: 0'
    assert_equal(0, measure.compute(archipelago), message)

    archipelago.connect(0, 1)
    archipelago.connect(0, 2)
    archipelago.connect(0, 3)
    message = 'No clusters: 0'
    assert_equal(0, measure.compute(archipelago), message)

    archipelago.connect(2, 3)
    message = 'One clusters: 1/3'
    assert_in_delta(0.2333333, measure.compute(archipelago), 0.1, message)

    archipelago.connect(1, 3)
    message = 'Two clusters: 2/4'
    assert_in_delta(1.0 / 3.0, measure.compute(archipelago), 0.1, message)
  end

  def get_archipelago(size)
    archipelago = Archipelago.new
    size.times do |_|
      archipelago.add_population(get_mock_population)
    end
    archipelago
  end

  def get_clustering_coefficient_measure
    ClusteringCoefficientMeasure.new
  end

  def get_mock_population
    PopulationMock.new
  end
end

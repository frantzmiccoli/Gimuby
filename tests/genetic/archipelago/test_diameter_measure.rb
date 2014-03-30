require './abstract_test_case'
require './mock/population_mock'
require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/archipelago/measure/diameter_measure'
require 'gimuby/genetic/archipelago/connect_strategy/circle_connect_strategy'

class TestDiameterMeasure < AbstractTestCase

  def test_compute
    size = 10
    archipelago = get_archipelago(size)
    measure = get_diameter_measure

    diameter = measure.compute(archipelago)
    message = 'No connected nodes, diameter should be big'
    assert(archipelago.get_nodes.length + 1 < diameter, message)

    circle_connect_strategy = get_circle_connect_strategy
    archipelago.connect_strategy = circle_connect_strategy
    archipelago.connect_all

    diameter = measure.compute(archipelago)
    message = 'Circle means that diameter is half of the number of nodes'
    assert_equal(archipelago.get_nodes.length  / 2, diameter, message)
  end

  def get_archipelago(size)
    archipelago = Archipelago.new
    size.times do |_|
      archipelago.add_population(get_mock_population)
    end
    archipelago
  end

  def get_circle_connect_strategy
    CircleConnectStrategy.new
  end

  def get_diameter_measure
    DiameterMeasure.new
  end

  def get_mock_population
    PopulationMock.new
  end

end
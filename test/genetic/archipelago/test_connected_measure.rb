require './abstract_test_case'
require './mock/population_mock'
require 'gimuby/genetic/archipelago/archipelago'
require 'gimuby/genetic/archipelago/measure/connected_measure'

class TestConnectedMeasure < AbstractTestCase

  def test_compute
    size = 10
    archipelago = get_archipelago(size)
    measure = get_connected_measure

    message = 'No connection, no connected'
    assert_equal(size, measure.compute(archipelago), message)

    archipelago.connect(0, 1)
    message = 'One connection, one class less'
    assert_equal(size - 1, measure.compute(archipelago), message)

    archipelago.connect(2, 1)
    message = 'Two connections, one class less'
    assert_equal(size - 2, measure.compute(archipelago), message)

    archipelago.connect(2, 0)
    message = 'Three connections, no class less '
    assert_equal(size - 2, measure.compute(archipelago), message)

    archipelago.connect(6, 7)
    message = 'Four connections, one class less'
    assert_equal(size - 3, measure.compute(archipelago), message)
  end

  def get_archipelago(size)
    archipelago = Archipelago.new
    size.times do |_|
      archipelago.add_population(get_mock_population)
    end
    archipelago
  end

  def get_connected_measure
    ConnectedMeasure.new
  end

  def get_mock_population
    PopulationMock.new
  end
end
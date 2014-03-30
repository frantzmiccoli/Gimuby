require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/archipelago/connect_strategy/fully_connected_connect_strategy'

class TestFullyConnectedConnectStrategy < AbstractTestCase
  def test_connect

    archipelago = get_mock_archipelago
    fully_connected_connect_strategy = get_fully_connected_connect_strategy
    archipelago.connect_strategy = fully_connected_connect_strategy
    archipelago.connect_all
    assert(archipelago.has_edge(0,1), 'All edges should be there')
    assert(archipelago.has_edge(1,2), 'All edges should be there')
    assert(archipelago.has_edge(2,3), 'All edges should be there')
    assert(archipelago.has_edge(4,5), 'All edges should be there')
    assert(archipelago.has_edge(4,1), 'All edges should be there')
    assert(archipelago.has_edge(1,5), 'All edges should be there')
    assert(archipelago.has_edge(3,5), 'All edges should be there')
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_fully_connected_connect_strategy
    FullyConnectedConnectStrategy.new
  end
end
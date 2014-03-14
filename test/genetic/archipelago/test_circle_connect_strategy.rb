require 'gimuby'
require './abstract_test_case'
require 'gimuby/genetic/archipelago/connect_strategy/circle_connect_strategy'
require 'gimuby/problem/sphere/sphere_solution'

class TestCircleConnectStrategy < AbstractTestCase

  def test_connect
    archipelago = get_mock_archipelago
    circle_connect_strategy = get_circle_connect_strategy
    archipelago.connect_strategy = circle_connect_strategy
    archipelago.connect_all
    assert(archipelago.has_edge(0,1), 'Circle edge should be there')
    assert(archipelago.has_edge(1,2), 'Circle edge should be there')
    assert(archipelago.has_edge(2,3), 'Circle edge should be there')
    assert(archipelago.has_edge(4,5), 'Circle edge should be there')
    assert(!archipelago.has_edge(4,1), 'Not circle edge should not be there')
    assert(!archipelago.has_edge(1,5), 'Not circle edge should not be there')
    assert(!archipelago.has_edge(3,5), 'Not circle edge should not be there')
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_circle_connect_strategy
    CircleConnectStrategy.new
  end
end
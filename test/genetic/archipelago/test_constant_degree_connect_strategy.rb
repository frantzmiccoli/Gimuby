require 'test/unit'
require 'gimuby/dependencies'
require 'gimuby/genetic/archipelago/connect_strategy/constant_degree_connect_strategy'

class TestConstantDegreeConnectStrategy < Test::Unit::TestCase

  def test_connect
    archipelago = get_mock_archipelago
    constant_degree_connect_strategy = get_constant_degree_connect_strategy
    constant_degree_connect_strategy.average_degree = 10.0
    archipelago.connect_strategy = constant_degree_connect_strategy
    archipelago.connect_all
    average_degree = archipelago.get_average_degree
    expected_degree = constant_degree_connect_strategy.average_degree
    tolerance = 2.0
    assert_in_delta(expected_degree, average_degree, tolerance,
                    'The expected degree should match the real one')
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_constant_degree_connect_strategy
    ConstantDegreeConnectStrategy.new
  end
end
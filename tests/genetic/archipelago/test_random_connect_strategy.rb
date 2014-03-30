require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/archipelago/connect_strategy/random_connect_strategy'

class TestRandomConnectStrategy < AbstractTestCase
  def test_connect
    archipelago = get_mock_archipelago
    random_connect_strategy = get_random_connect_strategy
    archipelago.connect_strategy = random_connect_strategy
    archipelago.connect_all
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_random_connect_strategy
    RandomConnectStrategy.new
  end
end
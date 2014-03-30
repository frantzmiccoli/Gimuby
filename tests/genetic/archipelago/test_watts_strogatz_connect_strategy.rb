require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/genetic/archipelago/connect_strategy/watts_strogatz_connect_strategy'


class TestWattsStrogatzConnectStrategy < AbstractTestCase

  def test_connect
    archipelago = get_mock_archipelago
    connect_strategy = get_watts_strogatz_connect_strategy
    archipelago.connect_strategy = connect_strategy
    connect_strategy.average_degree = 6.0
    connect_strategy.rewire_rate = 0.5
    archipelago.connect_all

    # The following compute the degree distribution ... which looks
    # utterly wrong
    degree_range = {}

    nodes = *(0..archipelago.populations.length - 1)
    nodes.each do |node|
      degree = archipelago.get_degree(node)
      degree_label = ((degree / 3).floor()) * 3

      if degree_range.has_key?(degree_label)
        degree_range[degree_label] += 1
      else
        degree_range[degree_label] = 1
      end
      #puts archipelago.get_degree(node)
    end
    puts '----ws'
    range_keys = degree_range.keys
    range_keys.sort!
    range_keys.each do |x|
      print x, ',', degree_range[x]
      puts ''
    end
  end

  def test_make_regular_latice
    archipelago = get_mock_archipelago
    connect_strategy = get_watts_strogatz_connect_strategy
    connect_strategy.average_degree = 2.0
    connect_strategy.send(:make_regular_latice, archipelago)
    assert(archipelago.has_edge(0, 1))
    assert(archipelago.has_edge(2, 1))
    assert(!archipelago.has_edge(3, 1))
    assert(!archipelago.has_edge(0, 3))
    connect_strategy.average_degree = 4.0
    connect_strategy.send(:make_regular_latice, archipelago)
    assert(archipelago.has_edge(0, 1))
    assert(archipelago.has_edge(2, 1))
    assert(archipelago.has_edge(3, 1))
    assert(!archipelago.has_edge(0, 3))
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_watts_strogatz_connect_strategy
    WattsStrogatzConnectStrategy.new
  end

end
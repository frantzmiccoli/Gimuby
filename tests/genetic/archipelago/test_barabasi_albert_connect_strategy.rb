require 'gimuby'
require './abstract_test_case'
require 'gimuby/genetic/population/population'
require 'gimuby/genetic/archipelago/connect_strategy/barabasi_albert_connect_strategy'
require 'gimuby/problem/sphere/sphere_solution'

class TestBarabasiAlbertConnectStrategy < AbstractTestCase

  def test_connect

    archipelago = get_mock_archipelago
    barabasi_albert_connect_strategy = get_barabasi_albert_connect_strategy
    archipelago.connect_strategy = barabasi_albert_connect_strategy
    archipelago.connect_all

    nodes = *(0..archipelago.populations.length - 1)
    nodes.sort! do |node1, node2|
      archipelago.get_degree(node1) <=> archipelago.get_degree(node2)
    end

    first_degree = archipelago.get_degree(nodes[0])
    last_degree = archipelago.get_degree(nodes[-1])

    assert(first_degree * 3 < last_degree,
           'The difference in degree should be important')

    expected_average_degree = barabasi_albert_connect_strategy.average_degree
    actual_average_degree = archipelago.get_average_degree
    delta = (expected_average_degree - actual_average_degree).abs

    assert(delta < 1, 'The edges should be provide the expected degree')


    # The following compute the degree distribution ... which looks
    # utterly wrong
    degree_range = {}

    nodes.each do |node|
      group_by = 1
      degree = archipelago.get_degree(node)
      degree_label = ((degree / group_by).floor()) * group_by

      if degree_range.has_key?(degree_label)
        degree_range[degree_label] += 1
      else
        degree_range[degree_label] = 1
      end
      #puts archipelago.get_degree(node)
    end
    puts '----'
    range_keys = degree_range.keys
    range_keys.sort!
    range_keys.each do |x|
      print x, ',', degree_range[x]
      puts ''
    end
    # require 'pp'
    # pp degree_range
  end

  def get_mock_archipelago
    factory = Gimuby.get_factory
    factory.connected_archipelago = FALSE
    factory.get_random_archipelago {next SphereSolution.new}
  end

  def get_barabasi_albert_connect_strategy
    BarabasiAlbertConnectStrategy.new
  end
end
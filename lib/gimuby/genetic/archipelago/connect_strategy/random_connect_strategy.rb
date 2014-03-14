require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'


class RandomConnectStrategy < ConnectStrategy

  def initialize
    @average_degree = 4.0
  end

  attr_accessor :average_degree

  def connect(archipelago)
    nodes = get_nodes(archipelago)
    connections_to_make = @average_degree * nodes.length
    check_connections_to_make(connections_to_make, nodes)
    made = 0
    begin
      from_node = nodes[rand(nodes.length)]
      to_node = nodes[rand(nodes.length)]
      has_edge = archipelago.has_edge(from_node, to_node)
      if from_node != to_node || has_edge
        archipelago.add_edge(from_node, to_node)
        made += 1
      end
    end while made < connections_to_make
    made
  end

end
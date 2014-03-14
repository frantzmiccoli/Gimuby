require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'

class WattsStrogatzConnectStrategy < ConnectStrategy

  def initialize
    @average_degree = 4.0
    @rewire_rate = 0.2
  end

  attr_accessor :average_degree
  attr_accessor :rewire_rate

  def connect(archipelago)
    make_regular_latice(archipelago)
    rewire(archipelago)
  end

  protected

  def make_regular_latice(archipelago)
    depth = (@average_degree / 2).floor
    depth.times do |i|
      # create a circle
      # then create a path with all second range neighbor
      # until reaching depth
      current_depth = i + 1
      current_depth.times do |first_node_index|
        # if depth = 2, there is two paths to build
        # [0, 2, 4, ...] and [1, 3, 5, ...]
        nodes = get_nodes(archipelago)
        path = []
        nodes.each_with_index do |key, node|
          if (key % current_depth) == first_node_index
            path.push(node)
          end
        end
        archipelago.connect_path(path, TRUE)
      end
    end
  end

  def rewire(archipelago)
    edges = get_edges_to_rewire(archipelago)
    nodes = get_nodes(archipelago)
    edges.each do |edge|
      node1 = edge[0]
      node2 = edge[1]
      if node1 < node2 # we do not process the other case (undirected model)
        should_rewire = @rewire_rate < rand()
        if should_rewire
          new_node = nodes.choice while archipelago.has_edge(node1, new_node)
          archipelago.remove_edge(node1, node2)
          archipelago.connect(node1, new_node)
        end
      end
    end
  end

  def get_edges_to_rewire(archipelago)
    archipelago.get_edges
  end

end
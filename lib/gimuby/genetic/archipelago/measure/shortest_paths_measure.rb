require 'gimuby/genetic/archipelago/measure/measure'

# Return the list of shortest path (Dijkstra) in Archipelago
class ShortestPathsMeasure < Measure

  def compute(archipelago)
    nodes = archipelago.get_nodes
    shortest_paths_length = []
    nodes.each do |node1|
      nodes.each do |node2|
        if node2 > node1
          length = get_shortest_path_length(archipelago, node1, node2)
          unless length.nil?
            shortest_paths_length.push(length)
          end
        end
      end
    end
    shortest_paths_length
  end

  private

  def get_shortest_path_length(archipelago, node1, node2)
    next_nodes = [node1]
    current_neighbor_distance = 0
    nodes_distances = {node1 => current_neighbor_distance}
    while next_nodes.length != 0
      current_node = next_nodes.shift
      current_neighbor_distance = nodes_distances[current_node] + 1
      neighbors = archipelago.get_neighbors(current_node)
      neighbors.each do |neighbor_node|
        already_processed = nodes_distances.has_key?(neighbor_node)
        unless already_processed
          next_nodes.push neighbor_node
          nodes_distances[neighbor_node] = current_neighbor_distance
        end
      end
      if nodes_distances.has_key?(node2)
        return nodes_distances[node2]
      end
    end
    nil
  end

end
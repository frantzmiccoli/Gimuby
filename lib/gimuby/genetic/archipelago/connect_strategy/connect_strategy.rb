
class ConnectStrategy

  # @param archipelago {Archipelago} The archipelago to connect
  # @api
  def connect(archipelago)
    raise NotImplementedError
  end

  protected

  def make_fully_connected(archipelago, nodes)
    nodes.each do |node1|
      nodes.each do |node2|
        if node1 < node2
          archipelago.connect(node1, node2)
          archipelago.connect(node2, node1)
        end
      end
    end
    nodes.length * (nodes.length - 1) * 2
  end

  def get_nodes(archipelago)
    populations_count = archipelago.populations.length
    return *(0..populations_count - 1)
  end

  def check_connections_to_make(connections_to_make, nodes)
    if nodes.length * (nodes.length - 1) < connections_to_make
      raise 'Not enough nodes'
    end
  end
end
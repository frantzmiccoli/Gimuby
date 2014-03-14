require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'


class FullyConnectedConnectStrategy < ConnectStrategy

  def connect(archipelago)
    nodes = get_nodes(archipelago)
    make_fully_connected(archipelago, nodes)
  end

end
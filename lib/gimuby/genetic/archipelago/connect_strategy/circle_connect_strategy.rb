require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'


class CircleConnectStrategy < ConnectStrategy

  def connect(archipelago)
    nodes = get_nodes(archipelago)
    archipelago.connect_path(nodes, TRUE)
  end

end
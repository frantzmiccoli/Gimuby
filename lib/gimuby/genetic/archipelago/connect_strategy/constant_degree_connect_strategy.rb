require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'

class ConstantDegreeConnectStrategy < ConnectStrategy

  def initialize
    @average_degree = 4.0
  end

  attr_accessor :average_degree

  def connect(archipelago)
    nodes = get_nodes(archipelago)

    # This won't create a graph where all nodes have same degree
    # since we may try to connect the same node twice
    number_times = (@average_degree.to_f / 2.0).round
    number_times.times do |_|
      archipelago.connect_path(nodes.shuffle!, TRUE)
    end
  end

end
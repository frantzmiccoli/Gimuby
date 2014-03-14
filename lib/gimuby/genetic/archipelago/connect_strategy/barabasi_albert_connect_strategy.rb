require 'gimuby/genetic/archipelago/connect_strategy/connect_strategy'
require 'gimuby/config'

class BarabasiAlbertConnectStrategy < ConnectStrategy

  def initialize
    @average_degree = 4.0
    @score_factor = 1.0
  end

  attr_accessor :average_degree
  attr_accessor :score_factor

  def connect(archipelago)
    nodes = get_nodes(archipelago)
    nodes.shuffle!

    edges_to_build_per_node = (@average_degree.to_f / 2.0).round

    handled_nodes = nodes.slice!(0, edges_to_build_per_node)

    # We make a fully connected component of those ones
    built = make_fully_connected(archipelago, handled_nodes)

    nodes.each do |node|
      built += connect_node(archipelago, handled_nodes, node)
      handled_nodes.push(node)
    end

    built
  end

  protected

  def connect_node(archipelago, handled_nodes, node)
    edges_to_build_per_node = (@average_degree.to_f / 2.0).round
    picked_nodes = pick_random_nodes(archipelago, handled_nodes, edges_to_build_per_node)
    picked_nodes.each do |picked_node|
      archipelago.connect(node, picked_node)
    end
    picked_nodes.length * 2
  end

  def pick_random_nodes(archipelago, handled_nodes, number_to_pick)
    scores = get_nodes_scores(archipelago, handled_nodes)
    scores_sum = scores.reduce(:+)
    picked = []
    begin
      min_score = rand() * scores_sum.to_f
      scores.each_index do |index|
        score = scores[index]
        if min_score < score
          #we pick this one
          node = handled_nodes[index]
          unless picked.include?(node)
            picked.push(node)
            break
          end
        else
          min_score -= score
        end
      end
    end while picked.length < number_to_pick
    picked
  end

  def get_nodes_scores(archipelago, nodes)
    nodes.map do |node|
      get_node_score(archipelago, node) * @score_factor
    end
  end

  def get_node_score(archipelago, node)
    archipelago.get_degree(node) + 1
  end

end
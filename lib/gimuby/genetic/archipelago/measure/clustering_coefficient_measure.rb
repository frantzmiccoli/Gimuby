require 'gimuby/genetic/archipelago/measure/measure'

# Compute the network average clustering coefficient as defined on
# http://en.wikipedia.org/wiki/Clustering_coefficient#Network_average_clustering_coefficient
# revision 19:31, 6 July 2013
#
# Beware if you update code, this class has a state don't break the
# workflow around the @potential_clusters member
class ClusteringCoefficientMeasure < Measure

  # @param archipelago [Archipelago]
  # @return [float] the clustering coefficient
  def compute(archipelago)
    local_clustering_coefficients = []
    archipelago.get_nodes.each do |node|
      local_clustering_coefficient = get_local_clustering_coefficient(archipelago, node)
      local_clustering_coefficients.push(local_clustering_coefficient)
    end
    local_clustering_coefficients.inject(:+) / local_clustering_coefficients.length.to_f
  end

  private

  def get_local_clustering_coefficient(archipelago, node)
    init_local_computation_properties
    potential_clusters_count = compute_potential_local_clusters(archipelago, node).length
    clusters_count = compute_real_local_clusters(archipelago).length
    if potential_clusters_count == 0
      return 0
    end
    clusters_count.to_f / potential_clusters_count.to_f
  end

  def init_local_computation_properties
    @potential_clusters = []
  end

  def compute_potential_local_clusters(archipelago, node)
    neighbors = archipelago.get_neighbors(node)
    neighbors.each do |neighbor1|
      neighbors.each do |neighbor2|
        #print '---------'
        #print "\n"
        #print neighbors.join('  ')
        #print "\n"
        #print node, ' ', neighbor1, ' ', neighbor2
        #print "\n"
        register_potential_clusters(node, neighbor1, neighbor2)
      end
    end
    @potential_clusters
  end

  def compute_real_local_clusters(archipelago)
    clusters = []
    @potential_clusters.each do |potential_cluster|
      node1 = potential_cluster[0]
      node2 = potential_cluster[1]
      node3 = potential_cluster[2]
      fully_connected = archipelago.has_edge(node1, node2) && \
                        archipelago.has_edge(node3, node2) && \
                        archipelago.has_edge(node1, node3)
      if fully_connected
        clusters.push(potential_cluster.clone)
      end
    end
    clusters
  end

  def register_potential_clusters(node1, node2, node3)
    if node1 == node2
      # invalid set
      return FALSE
    end
    nodes = [node1, node2]
    if nodes.include?(node3)
      # invalid set
      return FALSE
    end
    nodes.push(node3)
    nodes.each do |node|
      return FALSE if node.nil?
    end
    nodes.sort!
    if @potential_clusters.include?(nodes)
      # value already taken into account
      return FALSE
    end
    @potential_clusters.push(nodes)
    TRUE
  end
end
require 'gimuby/genetic/archipelago/measure/measure'
require 'gimuby/genetic/archipelago/measure/shortest_paths_measure'
require 'gimuby/genetic/archipelago/measure/connected_measure'


# Return the diameter of an archipelago
# If archipelago is not connex, simply output twice number of its nodes
class DiameterMeasure < Measure

  def compute(archipelago)
    unless is_connected(archipelago)
      return 2 * archipelago.get_nodes.length
    end
    get_biggest_shortest_paths(archipelago)
  end

  private

  def is_connected(archipelago)
    connected_measure = get_connected_measure
    connected_classes_count = connected_measure.compute(archipelago)
    connected_classes_count == 1
  end

  def get_biggest_shortest_paths(archipelago)
    paths_lengths = get_shortest_paths_measure.compute(archipelago)
    paths_lengths.max
  end

  def get_connected_measure
    ConnectedMeasure.new
  end

  def get_shortest_paths_measure
    ShortestPathsMeasure.new
  end

end
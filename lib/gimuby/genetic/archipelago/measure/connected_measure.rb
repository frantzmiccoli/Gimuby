require 'gimuby/genetic/archipelago/measure/measure'

# Return the number of connected class for an archipelago
class ConnectedMeasure < Measure

  # @param archipelago {Archipelago}
  def compute(archipelago)
    init_connected_classes(archipelago)
    old_signature = get_state_signature
    new_signature = ''
    until old_signature == new_signature
      old_signature = new_signature
      try_to_reduce(archipelago)
      new_signature = get_state_signature
    end
    get_connected_classes_count
  end

  private

  def init_connected_classes(archipelago)
    nodes = archipelago.get_nodes
    @connected_classes = {}
    nodes.each do |node|
      @connected_classes[node] = node
    end
  end

  def get_state_signature
    signature = ''
    @connected_classes.each do |k, v|
      signature = '|' + k.to_s + '-->' + v.to_s + "\n"
    end
    signature
  end

  def get_connected_classes_count
    different_classes = []
    @connected_classes.each do |_, connected_class|
      unless different_classes.include?(connected_class)
        different_classes.push(connected_class)
      end
    end
    different_classes.length
  end

  # @param archipelago {Archipelago}
  def try_to_reduce(archipelago)
    @connected_classes.each do |key1, value1|
      @connected_classes.each do |key2, value2|
        unless (key1 == key2) || (value1 == value2)
          if archipelago.has_edge(key1, key2)
            if value1 < value2
              @connected_classes[key2] = value1
            else
              @connected_classes[key1] = value2
            end
          end
        end
      end
    end
  end

end
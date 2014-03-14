require 'gimuby/config'

# Implement a TSP problem
class Tsp

  def initialize
    ensure_distance_matrix
  end

  def get_number_of_points
    @distance_matrix.length
  end

  def get_permutation_distance(permutation)
    previous = permutation[-1]
    distance = 0
    permutation.each do |current|
      marginal_distance = get_distance(previous, current)
      distance += marginal_distance
      previous = current
    end
    distance
  end

  def get_distance(from, to)
    @distance_matrix[from][to]
  end

  protected

  def ensure_distance_matrix
    path = $config.persistence_dir_path + '/TSP_distances_' +
        $config.tsp_number_points.to_s + '.data'
    load_distance_matrix(path)
    if @distance_matrix.nil?
      init_distance_matrix()
      persist_distance_matrix(path)
    end
  end

  def load_distance_matrix(path)
    if File::exists? path
      f = File.new(path, 'r')
      @distance_matrix = Marshal.load(f.read())
      f.close()
    end
  end

  def persist_distance_matrix(path)
    f = File.new(path, 'w')
    f.write(Marshal.dump(@distance_matrix))
    f.close()
  end

  def init_distance_matrix
    @distance_matrix = []
    max_index = $config.tsp_number_points - 1
    (0..max_index).each do |city_index1|
      @distance_matrix[city_index1] = []
      (0..max_index).each do |city_index2|
        if city_index1 != city_index2
          distance = get_random_distance
        else
          distance = 0
        end
        @distance_matrix[city_index1][city_index2] = distance
      end
    end
  end

  def get_random_distance
    min_value = -10000
    max_value = 10000
    rand(max_value - min_value) + min_value
  end
end
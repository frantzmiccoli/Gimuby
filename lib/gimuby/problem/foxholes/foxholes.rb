require 'gimuby/config'

# Implementation according to
# http://www.sfu.ca/~ssurjano/shekel.html
# http://www.zsd.ict.pwr.wroc.pl/files/docs/functions.pdf
#
class Foxholes

  @@x_value_min = -65536
  @@x_value_max = 65536

  def initialize
    ensure_holes_coordinates
  end

  def evaluate(x_values)
    sum = 0.0
    get_number_holes.times do |j|
      hole_coordinate = @holes_coordinates[j]
      sub_sum = 0.10
      hole_coordinate.each_index do |i|
        sub_sum += (x_values[i].to_f - hole_coordinate[i]) ** 2
      end
      sum += 1.0 / sub_sum
    end
    sum
  end

  protected

  def get_number_holes
    25
  end

  def get_holes_coordinates
    @holes_coordinates
  end

  def ensure_holes_coordinates
    path = $config.persistence_dir_path + '/foxholes_holes_coordinates_' +
        get_number_holes.to_s + '.data'
    load_holes_coordinates(path)
    if @holes_coordinates.nil?
      init_holes_coordinates
      persist_holes_coordinates(path)
    end
  end

  def load_holes_coordinates(path)
    if File::exists? path
      f = File.new(path, 'r')
      @holes_coordinates = Marshal.load(f.read())
      f.close()
    end
  end

  def persist_holes_coordinates(path)
    f = File.new(path, 'w')
    f.write(Marshal.dump(@holes_coordinates))
    f.close()
  end

  def init_holes_coordinates
    @holes_coordinates = []
    get_number_holes.times do |_|
      @holes_coordinates.push(get_random_coordinates)
    end
  end

  def get_random_coordinates
    scale = @@x_value_max - @@x_value_min
    x = rand() * scale + @@x_value_min
    y = rand() * scale + @@x_value_min
    [x, y]
  end
end
require 'gimuby/genetic/solution/check_strategy/check_strategy'

# Permutation goes represented as permutation from [0, ... l] indexes
class SolutionSpaceCheckStrategy < CheckStrategy

  def initialize
    @default_min = nil
    @default_max = nil
    @mins = {}
    @maxs = {}
  end

  def check(solution_representation)
    solution_representation.each_index do |index|
      value = solution_representation[index]

      if value.class == Array
        value = check(value)
      else
        min = get_min(index)
        unless min.nil?
          if value < min
            value = min
          end
        end

        max = get_max(index)
        unless max.nil?
          if value > max
            value = max
          end
        end
      end

      solution_representation[index] = value
    end

    solution_representation
  end

  def set_min(min, index = nil)
    if index.nil?
      @default_min = min
    else
      @mins[index] = min
    end
  end

  def set_max(max, index = nil)
    if index.nil?
      @default_max = max
    else
      @maxs[index] = max
    end
  end

  protected

  def get_min(index)
    min = @default_min
    if @mins.has_key?(index)
      min = @mins[index]
    end
    min
  end

  def get_max(index)
    max = @default_max
    if @maxs.has_key?(index)
      max = @maxs[index]
    end
    max
  end
end
require 'gimuby/config'
require 'gimuby/problem/schaffer/schaffer'
require 'gimuby/genetic/solution/function_based_solution'

class SchafferSolution < FunctionBasedSolution

  def evaluate
    get_schaffer.evaluate(@x_values.clone)
  end

  protected

  def get_x_value_min
    -100
  end

  def get_x_value_max
    100
  end

  def get_dimension_number
    2
  end

  def get_schaffer
    Schaffer.new
  end

end

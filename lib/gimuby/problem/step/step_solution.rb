require 'gimuby/config'
require 'gimuby/problem/step/step'
require 'gimuby/genetic/solution/function_based_solution'

class StepSolution < FunctionBasedSolution

  def evaluate
    get_step.evaluate(@x_values.clone)
  end

  protected

  def get_x_value_min
    -5.12
  end

  def get_x_value_max
    5.12
  end

  def get_dimension_number
    5
  end

  def get_step
    Step.new
  end

end
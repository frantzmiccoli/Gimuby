require 'gimuby'
require 'gimuby/genetic/solution/function_based_solution'

# This example tries to illustrate a function based optimization whose
# variables fit into an array and whose domain with the same bound for each
# variable.
# We stay on a simple example just to start for a more advanced usage
# see the second file

# Let's try do minimize x_1 * x_2 * x_3 for x_i in [-3; 3]

# STEP 1: First we define a solution
class SampleProblemSolution < FunctionBasedSolution

  def initialize(x_values = nil)
    super(x_values)
  end

  def evaluate
    product = 1.0
    @x_values.each do |x_value|
      product *= x_value
    end
    product
  end

  protected

  def get_x_value_min
    -3.0
  end

  def get_x_value_max
    3.0
  end

  def get_dimension_number
    3
  end
end


# STEP 2: Let's optimize it with an optimal population

factory = Gimuby.get_factory
factory.optimal_population = TRUE
# We inject a block that will provide solutions inside our population
optimizer = factory.get_population {next SampleProblemSolution.new}

100.times do
  optimizer.generation_step
end

# STEP 3: We get back the found solution
puts '[' + optimizer.get_best_solution.get_solution_representation.join(',') + ']'
puts optimizer.get_best_fitness


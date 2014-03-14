require 'gimuby/dependencies'
require 'gimuby/problem/rosenbrock/rosenbrock_solution'
require './problem/abstract_test_problem_solution'

class TestRosenbrockSolution < AbstractTestProblemSolution

  def get_solution
    RosenbrockSolution.new
  end

end

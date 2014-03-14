require 'gimuby/problem/tsp/tsp_solution'
require './problem/abstract_test_problem_solution'

class TestTSPSolution < AbstractTestProblemSolution

  def get_solution
    TspSolution.new
  end

end

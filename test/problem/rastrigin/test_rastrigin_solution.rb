require 'gimuby/problem/rastrigin/rastrigin_solution'
require './problem/abstract_test_problem_solution'

class TestRastriginSolution < AbstractTestProblemSolution

  def get_solution
    RastriginSolution.new
  end

end

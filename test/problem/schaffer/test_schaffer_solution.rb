require 'gimuby/dependencies'
require 'gimuby/problem/schaffer/schaffer_solution'
require './problem/abstract_test_problem_solution'

class TestSchafferSolution < AbstractTestProblemSolution

  def get_solution
    SchafferSolution.new
  end

end

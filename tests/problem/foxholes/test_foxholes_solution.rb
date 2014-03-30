require 'gimuby/dependencies'
require 'gimuby/problem/foxholes/foxholes_solution'
require './problem/abstract_test_problem_solution'

class TestFoxholesSolution < AbstractTestProblemSolution

  def get_solution
    FoxholesSolution.new
  end

end
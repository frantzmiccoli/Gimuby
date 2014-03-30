require 'gimuby/dependencies'
require 'gimuby/problem/sphere/sphere_solution'
require './problem/abstract_test_problem_solution'

class TestSphereSolution < AbstractTestProblemSolution

  def get_solution
    SphereSolution.new
  end

end
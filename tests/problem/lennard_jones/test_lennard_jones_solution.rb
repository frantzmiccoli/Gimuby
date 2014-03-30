require 'gimuby/problem/lennard_jones/lennard_jones_solution'
require './problem/abstract_test_problem_solution'

class TestLennardJonesSolution < AbstractTestProblemSolution

  def get_solution
    LennardJonesSolution.new
  end

end

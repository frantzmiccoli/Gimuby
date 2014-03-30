require 'gimuby/dependencies'
require 'gimuby/problem/step/step_solution'
require './problem/abstract_test_problem_solution'

class TestStepSolution < AbstractTestProblemSolution

  def get_solution
    StepSolution.new
  end

end
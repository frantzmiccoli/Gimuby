require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/step/step'

class TestStep < AbstractTestCase

  def test_evaluate
    sphere = Step.new

    self.assert(sphere.evaluate([0.0, 0.0]) == 0.0, 'Value should be 0.')
    self.assert(sphere.evaluate([4.0, 5.0]) == 9.0, 'Value should be 9.0.')
    self.assert(sphere.evaluate([4.1, 5.6]) == 9.0, 'Value should be 9.0.')
  end

end
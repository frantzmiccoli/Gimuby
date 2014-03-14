require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/problem/sphere/sphere'

class TestSphere < AbstractTestCase

  def test_evaluate
    position = [0.0, 0.0]

    sphere = Sphere.new

    self.assert(sphere.evaluate(position) == 0, 'Value should be 0.')
  end

end
require 'test/unit'

class AbstractTestCase < Test::Unit::TestCase

  # We seed the PRNG in order to have constant results in our tests
  def setup
    srand(31)
  end

  # here to avoid a warning
  def test_dummy
    if self.class == AbstractTestCase
      return
    end
  end

end

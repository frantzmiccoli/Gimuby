# Rosenbrock function (banana / valley function)
# Optimal is at (1, 1)
# http://en.wikipedia.org/wiki/Rosenbrock_function
class Rosenbrock

  def evaluate(values)
    x = values.shift
    y = values.shift
    term_1 = (1 - x) ** 2
    term_2 = 100 * (y - x ** 2) ** 2
    term_1 + term_2
  end

end
# Schaffer F6 function
#
# http://zhanggw.wordpress.com/2010/09/25/optimization-schaffer-f6-function-using-basic-genetic-algorithm-2/
class Schaffer

  def evaluate(values)
    x_values = values.clone
    x = x_values.shift
    y = x_values.shift
    sqrt_arg = x**2 + y**2
    sin_arg = Math.sqrt(sqrt_arg)
    numerator = Math.sin(sin_arg) ** 2 - 0.5
    denominator_part = 0.001 * ( x ** 2 + y ** 2 )
    denominator = (1 + denominator_part)**2
    0.5 + numerator/denominator
  end

end
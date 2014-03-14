# http://en.wikipedia.org/wiki/Rastrigin_function
class Rastrigin

  # @param x_values [Array<Float>]
  # @return Float
  def evaluate(x_values)
    a = get_a
    value = a * x_values.length
    x_values.each do |x_i|
      cos_arg = 2.0 * Math::PI * x_i
      sum_term_1 = (x_i ** 2.0)
      sum_term_2 = a * Math::cos(cos_arg)
      value += sum_term_1 - sum_term_2
    end
    value
  end

  protected

  # A Rastrigin parameter
  # @return Float
  def get_a
    10.0
  end

end
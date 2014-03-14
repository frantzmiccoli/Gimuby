class Sphere
  def evaluate(x_values)
    sum = 0
    x_values.each do |x_value|
      sum += x_value ** 2
    end
    sum
  end
end
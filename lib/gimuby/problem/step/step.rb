class Step
  def evaluate(x_values)
    sum = 0
    x_values.each do |x_value|
      sum += x_value.to_i
    end
    sum
  end
end
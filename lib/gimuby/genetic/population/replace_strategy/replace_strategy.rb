class ReplaceStrategy

  # Replace solution within the population
  # This function should call population.pick if selected is nil
  def replace(population, selected = nil)
    raise NotImplementedError
  end

end
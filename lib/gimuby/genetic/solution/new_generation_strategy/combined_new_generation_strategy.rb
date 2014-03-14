require 'gimuby/genetic/solution/new_generation_strategy/new_generation_strategy'

# This class pick randomly between strategies to implement more
# mitigated new generation strategy
class CombinedNewGenerationStrategy < NewGenerationStrategy

  def initialize
    @strategies = []
  end

  def reproduce(solution1, solution2)
    strategy = get_concrete_strategy
    strategy.reproduce(solution1, solution2)
  end

  # Add a strategy in the handled strategy of the system
  # @param strategy {NewGenerationStrategy}
  def add_strategy(strategy)
    @strategies.push(strategy)
  end

  protected

  def get_concrete_strategy
    @strategies.choice
  end
end
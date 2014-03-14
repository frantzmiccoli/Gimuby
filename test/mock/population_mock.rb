require 'gimuby/genetic/population/population'
require 'gimuby/genetic/population/pick_strategy/bests_pick_strategy'
require 'gimuby/genetic/population/replace_strategy/replace_worst_replace_strategy'

class PopulationMock < Population

  def initialize(solutions = nil)
    super(solutions)
    @pick_strategy = BestsPickStrategy.new
    @replace_strategy = ReplaceWorstReplaceStrategy.new

    30.times do |_|
      add_solution(get_mock_solution)
    end
  end

  def get_mock_solution
    PopulationMockSolutionMock.new
  end

end

class PopulationMockSolutionMock < SolutionMock

  def initialize(representation = nil)
    super()
    @fitness = rand
  end

  def reproduce(sol1, sol2)
    [sol1.clone, sol2.clone]
  end

  def mutate

  end
end
#!/usr/bin/env ruby
require 'gimuby/config'
require 'gimuby/dependencies'

# Base class for solutions, extended by each given problem
class Solution

  def initialize(representation = nil)
    @fitness = nil

    @check_strategy ||= nil
    @new_generation_strategy ||= nil
    @mutation_strategy ||= nil

    if representation.nil?
      init_representation
    else
      set_solution_representation(representation)
    end
  end

  attr_accessor :check_strategy
  attr_accessor :new_generation_strategy
  attr_accessor :mutation_strategy

  # @return [Float]
  def get_fitness
    unless has_fitness?
      @fitness = evaluate
      event_data = {:solution => self}
      get_event_manager.trigger_event(:on_solution_needs_evaluation, event_data)
    end
    @fitness
  end

  def mutate
    @mutation_strategy.mutate(self)
  end

  def reproduce(sol1, sol2)
    new_solutions_representations = @new_generation_strategy.reproduce(sol1, sol2)
    new_solutions_representations.map do |representation|
      solution = self.class.new(representation)
      solution.check
      solution.mutation_strategy = sol1.mutation_strategy
      solution.check_strategy = sol1.check_strategy
      solution.new_generation_strategy = sol1.new_generation_strategy
      solution
    end
  end

  def get_solution_representation
    raise NotImplementedError
  end

  def set_solution_representation(representation)
    raise NotImplementedError
  end

  protected

  def init_representation
    raise NotImplementedError
  end

  def has_fitness?
    not @fitness.nil?
  end

  def evaluate
    raise NotImplementedError
  end

  def check
    checked_representation = @check_strategy.check(get_solution_representation)
    set_solution_representation(checked_representation)
  end

  def get_event_manager
    $dependencies.event_manager
  end
end
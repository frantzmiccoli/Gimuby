require 'gimuby/factory'
require 'gimuby/event/event_manager'
require 'gimuby/problem/tsp/tsp'
require 'gimuby/problem/foxholes/foxholes'

# Dependencies container that is accessed from everywhere in the app
class Dependencies

  def initialize
    @event_manager = EventManager.new

    # problem specific
    @tsp = nil
    @foxholes = nil
  end

  attr_accessor :event_manager

  # problem specific

  def tsp
    if @tsp.nil?
      @tsp = Tsp.new
    end
    @tsp
  end

  def foxholes
    if @foxholes.nil?
      @foxholes = Foxholes.new
    end
    @foxholes
  end

end

$dependencies = Dependencies.new

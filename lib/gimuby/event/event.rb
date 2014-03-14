require 'gimuby/dependencies'

class Event

  # @param format [String]  The name of the event
  # @param data [Hash]      An Hash containing the data that will be passed
  #                         to the listeners
  # @api
  def initialize(name = nil?, data = {})
    @name = name
    @data = data
  end

  attr_accessor :name
  attr_accessor :data

  # Trigger the event (through the event manager)
  # @api
  def trigger
    event_manager = get_event_manager
    event_manager.trigger_event(name, self)
  end

  protected

  def get_event_manager
    $dependencies.event_manager
  end
end
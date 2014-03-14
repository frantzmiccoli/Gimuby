require 'gimuby/event/event'

# Core of the event managing system, this class stores listener and call them
# on event triggering.
class EventManager

  def initialize
    @listeners_registry = {} #contains array
  end

  # @param name {String} The event name
  # @param block {Block} The callback that will be call
  # @api
  def register_listener(name, &block)
    unless @listeners_registry.has_key? name
      @listeners_registry[name] = []
    end
    @listeners_registry[name].push block
  end

  # @param name {String}  The event name
  # @param event {Event}   The event object
  def trigger_event(name, event = {})
    if @listeners_registry.has_key? name
      if event.class == Hash
        event = Event.new(name, event)
      end
      listeners = @listeners_registry[name]
      listeners.each do |block|
        block.call event
      end
    end
  end
end
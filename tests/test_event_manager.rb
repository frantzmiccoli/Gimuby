require 'gimuby/dependencies'
require './abstract_test_case'
require 'gimuby/event/event_manager'
require 'gimuby/event/event'

class TestEventManager < AbstractTestCase

  def test_trigger
    #setup listener
    event_manager = get_event_manager
    event_manager.register_listener :event_type1 do |event|
      self.event_handling1 event
    end
    event_manager.register_listener :event_type2 do |event|
      self.event_handling2 event
    end

    event1 = Event.new :event_type1
    calls1 = 2
    calls1.times do
      event1.trigger
    end

    test_message = 'The listener should have been called has much time we\'ve triggered the event'

    assert_equal(calls1, @trigger_count1, test_message)

    event2 = Event.new :event_type2
    calls2 = 4
    calls2.times do
      event2.trigger
    end

    assert_equal(calls1, @trigger_count1, test_message)
    assert_equal(calls2, @trigger_count2, test_message)
  end

  def test_data_passing
    event_manager = get_event_manager
    event_manager.register_listener :event_type3 do |event|
      self.event_handling3 event
    end

    data_dict = {:content => 'hello'}

    event3 = Event.new(:event_type3, data_dict)
    event3.trigger

    assert(!@last_send_data3.nil?, 'Data should not be nil')
    assert_equal(data_dict[:content], @last_send_data3[:content],
           'Data should match send data')

    test_message = 'No other event listener should have been triggered'
    assert_equal(0, @trigger_count1, test_message)
    assert_equal(0, @trigger_count2, test_message)
  end

  def setup
    @trigger_count1 = 0
    @trigger_count2 = 0
    @last_send_data3 = nil
  end

  protected

  def event_handling1(event)
    @trigger_count1 += 1
  end

  def event_handling2(event)
    @trigger_count2 += 1
  end

  def event_handling3(event)
    @last_send_data3 = event.data
  end

  protected

  def get_event_manager
    $dependencies.event_manager
  end

end
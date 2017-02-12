module AggregateRoot
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def apply(event_class, &block)
      @event_handlers ||= {}
      @event_handlers[event_class] = block
    end
  end

  def <<(events)
    Array(events).inject(self, :apply)
  end

  def apply(event)
    event_handlers = self.class.instance_variable_get(:@event_handlers)
    if event_handler  = event_handlers[event.class]
      instance_exec(event, &event_handler)
    end
  end

  module Mutatable
    def initialize(event_sink)
      @event_sink = event_sink
    end

    def emit(klass, body)
      event = klass.new(body)
      #event_sink.sink(event)
      apply(event)
    end
  end
end

class Event
  def initialize(body)
    @body = body
  end

  attr_reader :body
end

class StartSubscription < Event
end

class EndSubscription < Event
end

class Subscription
  include AggregateRoot
  include AggregateRoot::Mutatable

  def foo
    puts 'FOO CALLED'
  end

  def start
    emit(StartSubscription, {})
  end

  apply(StartSubscription) { |e| self.foo; puts "LOL" }
end

subscription = Subscription.new(nil)
subscription.start

subscription << StartSubscription.new({})

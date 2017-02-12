module Potoroo
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

      def emit(klass, payload = {})
        event = @event_sink.sink(klass, payload)
        apply(event)
      end
    end
  end

  class EventSink
    def sink(klass, payload = {})
      klass.new(payload).tap { |event| (@events ||= []) << event }
    end
  end
end

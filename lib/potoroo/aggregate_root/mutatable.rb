module Potoroo
  module AggregateRoot
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
end

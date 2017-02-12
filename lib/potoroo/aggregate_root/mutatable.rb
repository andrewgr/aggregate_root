module Potoroo
  module AggregateRoot
    module Mutatable
      def initialize(event_sink)
        @event_sink = event_sink
      end

      private

      def emit(klass, payload = {})
        self << @event_sink.sink(klass, payload)
      end
    end
  end
end

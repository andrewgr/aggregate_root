module Potoroo
  module AggregateRoot
    include Projection

    def initialize(aggregate_id, event_sink)
      @aggregate_id, @event_sink = aggregate_id, event_sink
    end

    private

    def emit(klass, payload = {})
      self << @event_sink.sink(klass, @aggregate_id, payload)
    end
  end
end

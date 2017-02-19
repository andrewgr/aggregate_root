module Potoroo
  class EventSink
    def sink(klass, aggregate_id, payload = {})
      klass.new(aggregate_id: aggregate_id, payload: payload).tap do |event|
        (@events ||= []) << event
      end
    end
  end
end

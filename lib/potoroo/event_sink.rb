module Potoroo
  class EventSink
    def initialize(correlation_id: nil)
      @correlation_id = correlation_id
    end

    def sink(klass, payload = {})
      klass.new(@correlation_id, payload).tap do |event|
        (@events ||= []) << event
      end
    end
  end
end

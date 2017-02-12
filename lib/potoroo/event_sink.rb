module Potoroo
  class EventSink
    def sink(klass, payload = {})
      klass.new(payload).tap { |event| (@events ||= []) << event }
    end
  end
end

module Potoroo
  module Projection
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

    private

    def apply(event)
      event_handlers = self.class.instance_variable_get(:@event_handlers)

      if event_handler = event_handlers[event.class]
        instance_exec(event, &event_handler)
      end

      self
    end
  end
end

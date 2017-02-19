class Event
  def initialize(aggregate_id:, payload:)
    @aggregate_id = aggregate_id
    @payload = payload
  end

  attr_reader :aggregate_id

  def payload
    @payload.dup
  end
end

class PostAuthored < Event
  define_method :author, -> { payload[:author] }
  define_method :body,   -> { payload[:body] }
end

class PostPublished < Event
end

class PostHidden < Event
end

class PostUpdated < Event
  define_method :body,   -> { payload[:body] }
end

class PostRemoved < Event
end

class CommentAdded < Event
  define_method :author, -> { payload[:author] }
  define_method :body,   -> { payload[:body] }
end

class CommentUpvoted < Event
end

class CommentDownvoted < Event
end

class CommentReported < Event
end

class CommentRemoved < Event
end

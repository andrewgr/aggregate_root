class Event
  def initialize(payload)
    @payload = payload
  end

  def payload
    @payload.dup
  end
end

class PostAdded < Event
  define_method :author, -> { payload[:author] }
  define_method :body,   -> { payload[:body] }
end

class PostPublished < Event
end

class PostHidden < Event
end

class PostRemoved < Event
end

class CommentAdded < Event
end

class CommentUpvoted < Event
end

class CommentDownvoted < Event
end

class CommentReported < Event
end

class CommentRemoved < Event
end

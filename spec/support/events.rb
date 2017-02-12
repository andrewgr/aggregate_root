class Event
  def initialize(body)
    @body = body
  end

  attr_reader :body
end

class PostAdded < Event
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

class Post
  include Potoroo::AggregateRoot

  class Comment
    def initialize(author, body)
      @author = author
      @body   = body
    end

    attr_reader :author, :body
  end

  attr_reader :author, :body

  def add(author, body)
    emit PostAuthored, author: author, body: body
  end

  apply(PostAuthored) do |event|
    @author = event.author
    @body   = event.body
  end

  def authored?
    !@author.nil? && !@body.nil?
  end

  def publish
    raise 'Cannot published a post because it has not been authored yet' unless authored?
    emit PostPublished
  end

  apply(PostPublished) { |_| @published = true }

  def hide
    raise 'Cannot hide a post because it has not been authored yet' unless authored?
    emit PostHidden
  end

  apply(PostHidden) { |_| @published = false }

  def published?
    !!@published
  end

  def update(body)
    raise 'Cannot update a post because it has not been authored yet' unless authored?
    emit PostUpdated, body: body
  end

  apply(PostUpdated) do |event|
    @body = event.body
  end

  def comment(author, body)
    raise 'Cannot comment a post because it has not been authored yet' unless authored?
    raise 'Cannot comment a post because it is not published'          unless published?

    emit CommentAdded, author: author, body: body
  end

  apply(CommentAdded) do |event|
    @comments ||= []
    @comments << Comment.new(event.author, event.body)
  end

  def comments
    (@comments || []).dup
  end
end

class Post
  include AggregateRoot
  include AggregateRoot::Mutatable

  attr_reader :author, :body

  def add(author, body)
    emit PostAdded, author: author, body: body
  end

  apply(PostAdded) do |event|
    @author = event.author
    @body   = event.body
  end

  def authored?
    !@author.nil? && !@body.nil?
  end

  def publish
    emit PostPublished
  end

  apply(PostPublished) { |_| @published = true }

  def published?
    !!@published
  end

  def hide
    emit PostHidden
  end

  apply(PostHidden) { |_| @published = false }
end

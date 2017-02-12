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
    raise 'Cannot published a post because it has not been authored yet' unless authored?
    emit PostPublished
  end

  apply(PostPublished) { |_| @published = true }

  def published?
    !!@published
  end

  def hide
    raise 'Cannot hide a post because it has not been authored yet' unless authored?
    emit PostHidden
  end

  apply(PostHidden) { |_| @published = false }
end

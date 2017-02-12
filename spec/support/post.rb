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
end

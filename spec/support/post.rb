class Post
  include AggregateRoot
  include AggregateRoot::Mutatable

  def foo
    puts 'FOO CALLED'
  end

  def add(author, body)
    emit PostAdded, author: author, body: body
  end

  apply(PostAdded) { |e| self.foo; puts "LOL" }
end

require 'spec_helper'

describe AggregateRoot do
  let(:event_sink) { double(sink: nil) }
  subject(:post) { Post.new(event_sink) }

  specify do
    post.add('alice', 'Lorem ipsum')

    post << PostAdded.new({})
  end
end

require 'spec_helper'

describe AggregateRoot::Mutatable do
  let(:event_sink) { double(:<< => nil) }
  subject(:post) { Post.new(event_sink) }

  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.author }.from(nil).to('alice') }
  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.body }.from(nil).to('Lorem ipsum') }
  specify do
    post.add('alice', 'Lorem ipsum')
    expect(event_sink).to have_received(:<<).with(PostAdded)
  end
  specify do
    post_added_event = PostAdded.new(author: 'alice', body: 'Lorem ipsum')
    expect { post << post_added_event }.to change { post.author }.from(nil).to('alice')
  end

  specify { expect { post.publish }.to change { post.published? }.from(false).to(true) }
end

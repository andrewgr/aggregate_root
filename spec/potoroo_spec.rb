require 'spec_helper'

describe AggregateRoot::Mutatable do
  let(:event_sink) { double(:<< => nil) }
  subject(:post) { Post.new(event_sink) }

  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.author }.from(nil).to('alice') }

  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.body }.from(nil).to('Lorem ipsum') }

  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.authored? }.from(false).to(true) }

  specify do
    post.add('alice', 'Lorem ipsum')
    expect(event_sink).to have_received(:<<).with(PostAdded)
  end

  specify do
    post_added_event = PostAdded.new(author: 'alice', body: 'Lorem ipsum')
    expect { post << post_added_event }.to change { post.author }.from(nil).to('alice')
  end

  describe do
    context 'aggregate is in the state that allows the mutator to be called' do
      before { post.add('alice', 'Lorem ipsum') }
      specify { expect { post.publish }.to change { post.published? }.from(false).to(true) }
    end

    context 'aggregate is in the state that does not allow the mutator to be called' do
      specify { expect { post.publish }.to raise_error(RuntimeError) }
    end
  end
end

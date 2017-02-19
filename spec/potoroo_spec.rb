require 'spec_helper'

describe Potoroo::Projection do
  let(:event_sink) { Potoroo::EventSink.new }

  subject(:post) { Post.new(1, event_sink) }

  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.author }.from(nil).to('alice') }
  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.body }.from(nil).to('Lorem ipsum') }
  specify { expect { post.add('alice', 'Lorem ipsum') }.to change { post.authored? }.from(false).to(true) }

  describe do
    let(:post_authored_event) { PostAuthored.new(aggregate_id: 1, payload: { author: 'alice', body: 'Lorem ipsum' })}
    let(:event_sink) { double(sink: post_authored_event) }

    before { post.add('alice', 'Lorem ipsum') }

    specify { expect(event_sink).to have_received(:sink).with(PostAuthored, 1, author: 'alice', body: 'Lorem ipsum') }
  end

  specify do
    post_authored_event = PostAuthored.new(aggregate_id: 1, payload: { author: 'alice', body: 'Lorem ipsum' })
    expect { post << post_authored_event }.to change { post.author }.from(nil).to('alice')
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

  describe do
    let(:events) do
      [
        PostAuthored.new(aggregate_id: 1, payload: { author: 'alice', body: 'Lorem ipsum' }),
        PostUpdated.new(aggregate_id: 1, payload: { body: 'Lorem ipsum dolor' })
      ]
    end

    specify { expect { post << events }.to change { post.body }.from(nil).to('Lorem ipsum dolor') }
  end

  describe do
    before { post.add('alice', 'Lorem ipsum').publish() }

    specify { expect { post.comment('bob', 'Nice!') }.to change { post.comments.size }.from(0).to(1) }
  end
end

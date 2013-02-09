require 'spec_helper'

FakeActor = Struct.new(:thing, :block) do
  include LolConcurrency::Actor

  def call(n)
    block.call(n)
  end

  def call_with_block(n, &blk)
    blk.call(n)
  end
end

describe LolConcurrency::Actor do
  let(:object) { 'LolConcurrency' }

  describe 'instance' do
    subject { FakeActor.new(object, nil) }

    it { should respond_to(:thing) }
    it { should respond_to(:async) }
  end

  describe 'async' do
    let(:actor) { FakeActor.new(object, nil) }
    subject { actor.async }

    it { should respond_to(:thing) }
    it { should respond_to(:call) }
    it { should respond_to(:call_with_block) }

    it 'should return nil when you call methods on the async' do
      subject.thing.should be_nil
    end

    it 'should call methods passing arguments' do
      test = 1
      actor.block = ->(n) { test = n }
      subject.call(5)
      sleep(0.1)
      test.should == 5
    end

    it 'should pass blocks' do
      test = 1
      subject.call_with_block(2) do |n|
        test = n
      end
      sleep(0.1)
      test.should == 2
    end
  end
end

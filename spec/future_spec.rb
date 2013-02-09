require 'spec_helper'

FakeFuture = Struct.new(:thing) do
  include LolConcurrency::Future

  def call_slowly(n)
    sleep(n)
  end

  def call(n, &block)
    block.call(n)
  end
end

describe LolConcurrency::Future do
  let(:object) { 'LolConcurrency' }

  describe 'instance' do
    subject { FakeFuture.new(object) }

    it { should respond_to(:thing) }
    it { should respond_to(:future) }
  end

  describe 'future' do
    let(:fake) { FakeFuture.new(object) }
    subject { fake.future }

    it { should respond_to(:thing) }
    it { should respond_to(:call_slowly) }
    it { should respond_to(:call) }

    it 'should return the thing' do
      subject.thing.value.should == object
    end

    it 'should call methods passing arguments' do
      subject.call(5) do |n|
        n * 2
      end.value.should == 10
    end

    it 'should block and cache' do
      future = subject.call_slowly(2)
      start = Time.now
      value = future.value
      stop = Time.now
      value.should == 2
      (stop - start).should be_within(0.1).of(2.0)

      # Do it again, see that it's cached.
      start = Time.now
      value = future.value
      stop = Time.now
      value.should == 2
      (stop - start).should be_within(0.1).of(0.0)
    end
  end
end

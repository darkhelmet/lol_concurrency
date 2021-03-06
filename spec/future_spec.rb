require 'spec_helper'

FakeFuture = Struct.new(:thing) do
  include LolConcurrency::Future

  def call_slowly(n)
    sleep(n)
  end

  def call(n, &block)
    block.call(n)
  end

  def errored
    raise "What happens when the method call fails"
  end
end

ExtendedFakeFuture = Struct.new(:thing) do
  extend LolConcurrency::Future

  def self.call_slowly(n)
    sleep(n)
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

    it 'should defer errors' do
      future = subject.errored
      expect{ future.value }.to raise_error
    end

    context 'for class methods' do
      subject { ExtendedFakeFuture.future }

      it { should respond_to(:call_slowly) }

      it 'should work on the class level just like the instance level' do
        future = subject.call_slowly(2)
        expect(future.value).to eq(2)
      end
    end
  end
end

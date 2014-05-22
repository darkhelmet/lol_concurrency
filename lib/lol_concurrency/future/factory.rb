require 'forwardable'
require 'thread'
require 'lol_concurrency/future/future'

module LolConcurrency
  module Future
    class Factory
      extend Forwardable
      def_delegator :instance, :respond_to?

      attr_reader :instance
      private :instance

      def initialize(instance)
        @instance = instance
      end

      def method_missing(method, *args, &block)
        queue = SizedQueue.new(1)
        Thread.new do
          begin
            queue << instance.public_send(method, *args, &block)
          rescue => boom
            queue << boom
          end
        end
        Future.new(queue)
      end
    end
  end
end

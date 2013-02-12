require 'forwardable'
require 'thread'
require 'lol_concurrency/future/future'

module LolConcurrency
  module Future
    Factory = Struct.new(:instance) do
      extend Forwardable
      def_delegator :instance, :respond_to?

      private :instance

      def method_missing(method, *args, &block)
        queue = SizedQueue.new(1)
        Thread.new do
          queue << instance.public_send(method, *args, &block)
        end
        Future.new(queue)
      end
    end
  end
end

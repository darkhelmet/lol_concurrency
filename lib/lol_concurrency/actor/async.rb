require 'forwardable'
require 'thread'
require 'lol_concurrency/actor/context'

module LolConcurrency
  module Actor
    Async = Struct.new(:instance, :mailbox) do
      extend Forwardable
      def_delegator :instance, :respond_to?

      private :instance
      private :mailbox

      def initialize(instance)
        super(instance, Queue.new)
        run!
      end

      def method_missing(method, *args, &block)
        mailbox << Context.new(method, args, block)
        nil
      end

    private

      def run!
        Thread.new do
          loop do
            ctx = mailbox.pop
            instance.public_send(ctx.method, *ctx.args, &ctx.block)
          end
        end
      end
    end
  end
end

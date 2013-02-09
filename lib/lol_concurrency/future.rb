require 'forwardable'
require 'thread'
require 'monitor'

module LolConcurrency
  module Future
    Future = Struct.new(:queue) do
      include MonitorMixin

      private :queue

      def value
        @value ||= begin
          synchronize do
            @value ||= queue.pop
          end
        end
      end
    end

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

    def future
      @future ||= begin
        synchronize do
          @future ||= Factory.new(self)
        end
      end
    end

    def self.included(klass)
      unless klass < MonitorMixin
        klass.send(:include, MonitorMixin)
      end
    end
  end
end

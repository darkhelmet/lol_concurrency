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
  end
end

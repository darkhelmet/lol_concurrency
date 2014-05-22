require 'monitor'

module LolConcurrency
  module Future
    Future = Struct.new(:queue) do
      include MonitorMixin

      private :queue

      def value
        @value ||= begin
          synchronize do
            @value ||= begin
              v = queue.pop
              raise v if Exception === v
              v
            end
          end
        end
      end
    end
  end
end

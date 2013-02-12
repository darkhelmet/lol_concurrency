require 'monitor'
require 'lol_concurrency/actor/async'

module LolConcurrency
  module Actor
    def async
      @async ||= begin
        synchronize do
          @async ||= Async.new(self)
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

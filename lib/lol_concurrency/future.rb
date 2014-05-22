require 'lol_concurrency/future/factory'

module LolConcurrency
  module Future
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

    def self.extended(klass)
      unless klass.singleton_class < MonitorMixin
        klass.send(:extend, MonitorMixin)
      end
    end
  end
end

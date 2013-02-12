module LolConcurrency
  module Actor
    Context = Struct.new(:method, :args, :block)
  end
end

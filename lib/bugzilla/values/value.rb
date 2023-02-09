module Bugzilla
  class Value
    def initialize(value)
      @value = value
    end

    def call
      unless [Config::MemoizedValue, Config::LazyValue].include?(@value.class)
        return @value
      end

      @value.call
    end
  end
end

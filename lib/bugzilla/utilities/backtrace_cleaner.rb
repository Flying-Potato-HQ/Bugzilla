module Bugzilla
  module BacktraceCleaner
    def default_backtrace
      lambda { |trace|
        trace.reject do |line|
          line =~ /\b(internal|gems|rubies|my_tools)\b/
        end
      }
    end

    def default_ignored_paths
      # ["rubies", "gems", "active_support", "internal", "my_tools", "internal", "bugzilla", "config/initializers"]
      ["internal"]
    end

    def temp_ignored_methods
      ["columns"]
    end

    def should_ignore_path?(path)
      default_ignored_paths.any? { |p| path.include?(p) }
    end

    def should_ignore_method?(method)
      temp_ignored_methods.any? { |p| method.include?(p) }
    end
  end
end

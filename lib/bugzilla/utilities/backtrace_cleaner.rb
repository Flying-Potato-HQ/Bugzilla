module Bugzilla
  module BacktraceCleaner

    def default_backtrace
      lambda { |trace|
        trace.reject do |line|
          line =~ /\b(internal|gems)\b/
        end
      }
    end

    def default_ignored_paths
      %w[gems active_support internal]
    end

    def should_ignore_path?(path)
      default_ignored_paths.any? { |p| path.include?(p) }
    end
  end
end

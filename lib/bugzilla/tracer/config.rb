module Bugzilla
  class Tracer
    class Config
      include BacktraceCleaner

      attr_accessor :colourise, :backtrace_cleaner, :ignored_paths, :level,
                    :colour_opts

      def initialize(**args)
        args.each do |key, value|
          instance_variable_set("@#{key}", value)
        end

        @level = args[:level] || :full
        @colourise = args[:colourise] || false
        @backtrace_cleaner = args[:backtrace_cleaner] || nil
        @ignored_paths = args[:ignored_paths] || []

        @colour_opts = {
          event: args.dig(:colorize, :event) || COLORS[:purple],
          path: args.dig(:colorize, :path) || COLORS[:blue],
          lineno: args.dig(:colorize, :lineno) || COLORS[:light_red],
          method_id: args.dig(:colorize, :method_id) || COLORS[:light_green],
          args: args.dig(:colorize, :args) || COLORS[:light_blue],
          defined_class: args.dig(:colorize, :defined_class) || COLORS[:blue],
          return_value: args.dig(:colorize, :return_value) || COLORS[:light_green],
          exception: args.dig(:colorize, :exception) || COLORS[:light_red],
          instance_variables: args.dig(:colorize, :instance_variables) || COLORS[:cyan],
          local_variables: args.dig(:colorize, :local_variables) || COLORS[:white],
          object_id: args.dig(:colorize, :object_id) || COLORS[:yellow]
        }
      end

      def colorize?
        @colourise
      end

      def defaults
        {
          level: :full,
          colorize: true,
          backtrace_cleaner: default_backtrace
        }
      end
    end
  end
end

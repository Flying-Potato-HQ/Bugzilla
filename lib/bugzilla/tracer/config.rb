module Bugzilla
  class Tracer
    class Config
      include BacktraceCleaner

      attr_accessor :colourise, :backtrace_cleaner, :ignored_paths, :level,
                    :colour_opts, :gsub_filters, :disable_filter, :watched_events

      def initialize(**args)
        args.each do |key, value|
          instance_variable_set("@#{key}", value)
        end

        @disable_filter = args[:disable_filter] || false
        @level = args[:level] || :full
        @colourise = args[:colourise] || false
        @backtrace_cleaner = args[:backtrace_cleaner] || nil
        @ignored_paths = args[:ignored_paths] || []
        @gsub_filters = args[:gsbub_filter] || default_gsub_filter
        @watched_events = args[:watched_events] || [:call, :return, :raise]

        @colour_opts = {
          event: args.dig(:colorize, :event) || COLORS[:purple],
          path: args.dig(:colorize, :path) || COLORS[:light_blue],
          lineno: args.dig(:colorize, :lineno) || COLORS[:light_red],
          method_id: args.dig(:colorize, :method_id) || COLORS[:light_green],
          args: args.dig(:colorize, :args) || COLORS[:white],
          defined_class: args.dig(:colorize, :defined_class) || COLORS[:blue],
          return_value: args.dig(:colorize, :return_value) || COLORS[:white],
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

      def default_gsub_filter
        ["/home/ruby/core/repo/"]
      end

      def gsub_filter!(str)
        gsub_filters.each do |gsub|
          str = str.gsub(gsub, '')
        end
        str
      end
    end
  end
end

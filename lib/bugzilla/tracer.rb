# frozen_string_literal: true

module Bugzilla

  class Tracer

    delegate :backtrace_cleaner, to: :config
    delegate :colorize?, to: :config
    delegate :level, to: :config
    delegate :colour_opts, to: :config

    include Enumerable
    include BacktraceCleaner

    attr_accessor :config, :traces

    def initialize
      @config = Config.new
      @traces = []
    end

    def self.perform!(&block)
      self.new.execute(&block)
    end

    def execute(&block)
      tp = TracePoint.new(:call, :return, :raise) do |trace|
        unless should_ignore_path?(trace.path)
          traces << Trace.new(trace)
        end
      end

      tp.enable
      block.call
      tp.disable
      self
    end

    def each
      @traces.each { |trace| yield trace }
    end

    def trace(*args)
      traces.each do |t|
        puts build_line(t, *args)
      end
      nil
    end

    def source_trace
      traces.map do |t|
        case t.event
        when :return
          t.source_code
        when :return
          "Return".white + " #{t.return_value}".cyanish + "    from #{t.method_id}"
        when :raise
          "Exception: #{t.exception}".red
        end
      end
    end

    def build_line(trace, *args)
      line = [
        colourise(trace.event, :event), colourise(trace.path, :path),
        colourise(trace.lineno, :lineno), colourise(trace.method_id, :method_id)
      ].join(' ')

      return line unless args
      line + "\n" + args.map do |arg|
        colourise(trace.send(arg), arg)
      end.join('   ')
    end

    def colourise(text, arg)
      arg.to_sym if arg.is_a?(String)
      return "\e[#{colour_opts[arg]}m#{text}\e[0m" if colour_opts.key?(arg)
      text
    end
  end
end

# frozen_string_literal: true

module Bugzilla

  class Tracer

    include Enumerable
    include OutputHelper
    include SearchHelper
    include BacktraceCleaner

    delegate :backtrace_cleaner, to: :config
    delegate :colorize?, to: :config
    delegate :level, to: :config
    delegate :colour_opts, to: :config
    delegate :gsub_filter!, to: :config
    delegate :disable_filter, to: :config
    delegate :watched_events, to: :config


    attr_accessor :config, :traces, :ignored_traces_count

    def initialize
      @config = Config.new
      @traces = []
      @ignored_traces_count = 0
    end

    def self.perform!(&block)
      self.new.execute(&block)
    end

    def self.simple!(&block)
      self.new.simple_execute(&block)
    end

    def simple_execute(&block)
      tp = Tracer.new(:call, :raise) do |trace|
        @traces << Trace.new("class: #{trace.defined_class}, path: #{trace.path}, lineno: #{trace.lineno}, method_id: #{trace.method_id}")
      end

      tp.enable
      block.call
      tp.disable
      puts @traces
    end

    def execute(&block)
      tp = TracePoint.new(*watched_events) do |trace|
        if !disable_filter && ignore_path?(trace)
          @ignored_traces_count += 1
        else
          traces << Trace.new(trace)
        end
      end

      tp.enable
      block.call
      tp.disable
      self
    end

    def each(&block)
      @traces.each(&block)
    end

    def trace(*args)
      traces.each do |t|
        puts build_line(t, *args)
      end
      nil
    end


    protected

    def ignore_path?(trace)
      should_ignore_path?(trace.path) || should_ignore_method?(trace.method_id.to_s)
    end

    def colourise(text, arg)
      arg.to_sym if arg.is_a?(String)
      return "\e[#{colour_opts[arg]}m#{text}\e[0m" if colour_opts.key?(arg)
      text
    end

  end
end

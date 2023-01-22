# frozen_string_literal: true

module Bugzilla

  class Tracer

    include Handlers
    include Enumerable

    attr_accessor :config, :trace, :events

    def initialize(events = [], **args)
      @events = events
      @trace = nil

      @config = Config.new(**args)
      @trace_complete = false
    end

    def trace!(&block)
      raise ArgumentError, "Block required" unless block_given?

      begin
        @trace = self.perform!(&block)
        @trace_complete = true
        @trace
      rescue => e
        clean_trace(e)
      end
    end

    def perform!(&block)
      raise ArgumentError, "Block required" unless block_given?

      @trace = TracePoint.new(:call, :return) do |tp|
        next if tp.defined_class.to_s.in?(["Pry", "Bugzilla"])

        # binding.pry
        @events.shift if @events.size > 1000
        @events << Traceable.new(tp)
      end

      @trace.enable(&block)
      @trace_complete = true

      self
    end

    def trace_complete?
      @trace_complete
    end

    def each
      @events.each { |item| yield item }
    end
  end
end

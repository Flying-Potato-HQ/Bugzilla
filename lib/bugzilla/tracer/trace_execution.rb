# frozen_string_literal: true

module Bugzilla
  class Tracer
    class TraceExecution
      attr_accessor :block, :executions, :events
      def initialize(**args, &block)
        raise ArgumentError, "Block required" unless block_given?

        @block = block
        @events = []
        @trace = nil

        begin_trace
      end

      private

      def perform_trace(&block)
        @trace = TracePoint.new(:call, :return) do |tp|
          next if tp.defined_class.to_s.in?(["Pry", "Bugzilla"])

          # @events.shift if @events.size > 100
          @events << Traceable.new(tp)
        end

        @trace.enable
      end

      def run_trace(trace_point)
        trace_point.enable
        @block.call
        trace_point.disable
        @block = nil
      end
    end
  end
end



# frozen_string_literal: true

module Bugzilla
  class Tracer

    attr_accessor :block, :config, :executions
    def initialize(**args, &block)
      raise ArgumentError, "Block required" unless block_given?

      @block = block
      @executions = []
      @config = Config.new(**args)

      @executions << TraceExecution.new { @block }
    end

    # def execute_trace
    #   @executions << TraceExecution.new(block: @block).trace
    # end

    def trace(&block)
      puts "Starting trace"
      last_execution.begin_trace
      puts "Running trace"
      yield
      puts "Ending trace"
      last_execution.end_trace
      puts "Trace complete"
    end

    def last_execution
      @executions.last
    end

  end
end
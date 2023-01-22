# frozen_string_literal: true

module Bugzilla

  def clean_trace(backtrace)
    res = backtrace.map do |trace|
      trace = trace.split("/lib/").last
      CodeRay.scan(trace, :ruby).term
    end

    puts res
  end

  class Tracer

    attr_accessor :block, :config, :executions
    def initialize(**args, &block)
      raise ArgumentError, "Block required" unless block_given?

      @block = block
      @executions = []
      @config = Config.new(**args)

      @executions << TraceExecution.new
    end


    def trace(&block)
      begin
        last_execution.perform(&block)
      rescue => exception
        clean_trace(exception.backtrace)
      end
    end


    def last_execution
      @executions.last
    end

  end
end

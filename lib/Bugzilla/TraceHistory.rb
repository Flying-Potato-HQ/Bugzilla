# frozen_string_literal: true

class TraceHistory
  include Enumerable

  attr_accessor :history
  def initialize(trace = nil)
    @history = []
    @history << trace if trace
  end

  def each
    @history.each { |item| yield item }
  end

  def <<(trace)
    @history << trace
  end
end
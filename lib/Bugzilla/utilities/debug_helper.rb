# frozen_string_literal: true

require_relative "../formatter"

module Bugzilla
  module DebugHelper

    include Formatter

    def stack
      stack = clean_trace
      stack.map do |string|
        string = string.gsub("/home/ruby/core/repo", "")
        puts string.yellow
      end
      nil
    end

    # def caller(verbose: false)
    #   caller = super
    #   clean_trace(caller) unless verbose
    # end

    def calling_method
      caller[0][/`([^']*)'/, 1]
    end

    def caller_loc
      caller[0].split("/").last
    end
  end
end

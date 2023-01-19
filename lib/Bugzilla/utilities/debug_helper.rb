# frozen_string_literal: true

module Bugzilla
  module DebugHelper

    include Bugzilla::Formatter

    def stack
      stack = clean_trace
      stack.map do |string|
        string = string.gsub("/home/ruby/core/repo", "")
        puts string.yellow
      end
      nil
    end

    def caller
      caller = super
      clean_trace(caller)
    end

    def calling_method
      caller[0][/`([^']*)'/, 1]
    end

    def calling_method
      caller[0].split("/").last
    end
  end
end

# frozen_string_literal: true

require_relative "Bugzilla/utilities/tty_helpers"
require_relative "Bugzilla/utilities/debug_helper"
require_relative "Bugzilla/formatter"
require_relative "Bugzilla/tracer"
require_relative "Bugzilla/version"

require 'awesome_print'

module Bugzilla
  include Formatter
  include TTYHelpers

  # Object.include DebugHelper

  def trace(&block)
    bind = block.call.send(:binding)
    stack = generate_trace(bind)
    res = []

    stack.map do |loc|
      res << Tracer.new(loc, bind)
    end

    menu(res)
  end


  def menu(trace_result)
    return unless trace_result
    system 'clear'

    prompt.select("Select a line to inspect", per_page: 20) do |menu|
      trace_result.each do |trace|
        menu.choice trace.trace_info.to_s.gsub("/home/ruby/core/repo", "").yellow, -> { menu_trace(trace); menu(trace_result) }
      end
      menu.choice "Back".white, -> {  }
    end
  end

  def menu_trace(trace)
    system 'clear'

    puts "Instance Variables: ".white + "#{trace.__binding__.instance_variables.map {|var| "#{var.to_s}: #{var.instance_variable_get(var)}"}}".yellow

    prompt.select("Select an option", per_page: 20) do |menu|
      menu.choice "View Source".green, -> { trace.view_source; await_input; menu_trace(trace) }
      menu.choice "[Console] Bind Generic".green, -> { trace.bind_generic; await_input; menu_trace(trace) }
      menu.choice "[Console] Binding".green, -> { trace.bind_source; await_input; menu_trace(trace) }
      menu.choice "[Console] Block Binding".green, -> { trace.bind_source; await_input; menu_trace(trace) }
      menu.choice "View Variables".green, -> { trace.view_variables; await_input; menu_trace(trace) }
      menu.choice "Back".white, -> {  }
    end
  end

  private

  def generate_trace(binding)
    stack = binding.send(:caller_locations)
    clean_trace(stack)
  end
end

# frozen_string_literal: true

require_relative "../example/entry"
require_relative "Bugzilla/utilities/tty_helpers"
require_relative "Bugzilla/utilities/debug_helper"
require_relative "Bugzilla/utilities/generic_helpers"
require_relative "Bugzilla/formatter"
require_relative "Bugzilla/tracer"
require_relative "Bugzilla/version"

require "awesome_print"

module Bugzilla
  include Formatter
  include TTYHelpers
  include GenericHelpers
  include Entry

  Object.include DebugHelper

  def dot
    mini_trace { terminal_width * terminal_height; example}
  end

  def mini_trace(&block)
    events = []
    trace = TracePoint.new(:call, :return, :raise) do |tp|
      events << Tracer.new(tp) unless BLACKLISTED_LOCATIONS.select { |p|
        p.include? tp.path }.any?
    end

    trace.enable
    block.call
    trace.disable
    trace_log_menu(events)
  end



  def trace_log_menu(trace_result)
    return unless trace_result

    system "clear"
    Binding

    prompt.select("Select a line to inspect", per_page: 20) do |menu|
      offset = get_standardised_offset(trace_result.select {|e| e.event == :call || e.event == :return}.map(&:short_loc))

      trace_result.each do |trace|
        next unless trace.event == :call || trace.event == :return

        menu.choice trace.pp_to_s(offset), lambda {
          trace.trace_menu; trace_log_menu(trace_result) }
      end
      menu.choice "Back".white, -> { }
    end
  end

  def example
    calculate_thing(dogs: 24, cats: 15, birds: 3)
  end

  # def menu_trace(trace)
  #   system "clear"
  #
  #   puts "Instance Variables: ".white + trace.instance_variables.join(" ").to_s.yellow
  #   puts "Local Variables: ".white + trace.local_variables.join(" ").to_s.yellow + "\n"
  #
  #   prompt.select("Select an option", per_page: 20) do |menu|
  #     menu.choice "View Source".green, -> { trace.view_source; await_input; menu_trace(trace) }
  #     menu.choice "[Console] Bind Generic".green, -> { trace.bind_generic; await_input; menu_trace(trace) }
  #     menu.choice "[Console] Binding".green, -> { trace.bind_source; await_input; menu_trace(trace) }
  #     menu.choice "[Console] Block Binding".green, -> { trace.bind_source; await_input; menu_trace(trace) }
  #     menu.choice "View Variables".green, -> { trace.view_variables; await_input; menu_trace(trace) }
  #     menu.choice "Back".white, -> {  }
  #   end
  # end

  private

  def generate_trace(binding, succinct: false)
    stack_trace = binding.send(:caller_locations)
    stack_trace = clean_trace(stack_trace) if succinct

    stack_trace
  end


end

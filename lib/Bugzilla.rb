# frozen_string_literal: true

require_relative "Bugzilla/version"

module Bugzilla
  class Error < StandardError; end

  def trace_history
    @history ||= TraceHistory.new
  end
  def trace(&block)
    @bind = block.call.send(:binding)
    generate_trace(@bind)
    res = []

    stack.map do |loc|
      res << Tracer.new(loc, @bind)
      # string = loc.path.to_s.gsub("/home/ruby/core/repo", "")
      # puts string.yellow
    end

    trace_history << res
    menu(res)
  end

  def stack(&block)
    @bind = block.call.send(:binding)
    generate_trace(@bind)

    stack.map do |loc|
      string = loc.path.to_s.gsub("/home/ruby/core/repo", "")
      puts string.yellow
    end

    nil
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

    stack = stack.reject { |string| string.to_s =~ /\/(gems|rubies|middleware|)\// }
    stack = stack.reject do |loc|
      loc.to_s.include?("goldiloader") ||
        loc.to_s.include?("application_controller") ||
        loc.to_s.include?("prosopite") ||
        loc.to_s.include?("pry") ||
        loc.to_s.include?("backend/platform") ||
        loc.to_s.include?("irb") ||
        loc.to_s.include?("/bin/rails")
    end
  end
end

# frozen_string_literal: true
require_relative "./utilities/menu"


module Bugzilla
  class Tracer

    include Menu

    attr_reader :attrs, :exception, :return_value
    def initialize(e, *events)
      @attrs = {
        path: e.path,
        lineno: e.lineno,
        event: e.event,
        method_id: e.method_id,
        defined_class: e.defined_class,
        cached_binding: e.binding
      }
      @attrs.merge({
        local_variables: local_variables,
        instance_variables: instance_variables
      })
      @exception = e.raised_exception if e.event == :raise
      @return_value = e.return_value if e.event == :return
      @attrs.merge({ params: e.parameters }) if e.event == :call

      @actions = {
        "Inspect": -> { ap overview },
        "Pry Binding": -> { cached_binding.pry },
        "Pry Tracer": -> { binding.pry },
        "Back": -> { nil },
        "Quit": -> { exit }
      }
    end

    def overview
      puts "    - - - -Event: #{event}".yellow + " #{method_id}".white
      puts " Instance Variables: ".white + instance_variables.join(" ").to_s.yellow
      puts "#{" Local Variables: ".white}#{local_variables.join(" ").to_s.yellow}\n"

      puts "\n   #{path}".white + " #{lineno}".yellow
      puts "   Params: ".white + params.to_s.white if params
      puts "   Return Value: ".white + return_value.to_s.white if return_value
      puts "   Exception: ".white + exception.to_s.white if exception

    end

    def pp_to_s(offset = 0)
      calced_offset = " " * (offset - short_loc.length if offset >= short_loc.length)
      event_offset = " " * (12 - get_event.length)
      vars_offset = " " * 3

      r = "#{get_event}".yellow + event_offset +  short_loc.black + calced_offset + "  #{method_id}".blue + vars_offset + "   #{print_vars_short}".green
      r + "    #{return_value}".white if return_value
      r
    end

    def to_s
      p = path.gsub /\/Users\/samuelodonnell\/Documents\/Projects\/Personal/, ""
      "#{get_event}" + p.to_s + ":#{lineno}" + "    #{method_id}"
    end

    def get_event
      event.to_s.capitalize
    end

    def short_loc
      p = path.gsub /\/Users\/samuelodonnell\/Documents\/Projects\/Personal/, ""
      p.to_s + ":#{lineno}"
    end

    def trace_menu
      create_menu(@actions)
    end

    def print_vars_short
      "Local vars: #{local_variables.reject {|e| e.nil? }.count}  Instance: #{instance_variables.reject {|e| e.nil? }.count}"
    end

    def path
      @attrs[:path]
    end

    def params
      @attrs[:params]
    end

    def lineno
      @attrs[:lineno]
    end

    def event
      @attrs[:event]
    end

    def method_id
      @attrs[:method_id]
    end

    def defined_class
      @attrs[:defined_class]
    end

    def cached_binding
      @attrs[:cached_binding]
    end

    def return_value
      @return_value
    end

    def exception
      @exception
    end

    def variables
      {
        local_vars: local_variables,
        instance_vars: instance_variables
      }
    end

    def local_variables
      @local_variables ||= {}
      cached_binding.local_variables.each {|var| @local_variables[var] = cached_binding.local_variable_get(var)}
    end

    def instance_variables
      @instance_variables ||= {}
      cached_binding.instance_variables.each {|var| @instance_variables[var] = cached_binding.instance_variable_get(var)}
    end

  end
end

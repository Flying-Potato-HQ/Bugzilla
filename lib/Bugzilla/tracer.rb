# frozen_string_literal: true
require_relative "./utilities/menu"


module Bugzilla
  class Tracer

    include Menu

    attr_reader :attrs, :exception, :return_value
    def initialize(e, *events)
      puts "Event: #{e.event}".yellow + " #{e.method_id}".white
      # e = super(*events)

      @attrs = {
        path: e.path,
        params: e.parameters,
        lineno: e.lineno,
        event: e.event,
        method_id: e.method_id,
        defined_class: e.defined_class,
        binding: e.binding,
        local_variables: local_variables,
        instance_variables: instance_variables
      }
      @exception = e.raised_exception if e.event == :raise
      @return_value = e.return_value if e.event == :return

      @actions = {
        "Inspect": -> { ap overview },
        "Variables": -> { ap variables },
        "Path": -> { path },
        "Params": -> { binding.pry },
        "Line Number": -> { lineno },
        "Event": -> { event },
        "Method ID": -> { method_id },
        "Defined Class": -> { defined_class },
        "Binding": -> { binding },
        "Back": -> { nil },
        "Quit": -> { exit }
      }

      @actions.merge({ "Return Value": return_value }) if @return_value
      @actions.merge({ "Exception": exception }) if @exception
    end
    
    def overview
      puts "    - - - -Event: #{event}".yellow + " #{method_id}".white
      puts " Instance Variables: ".white + instance_variables.join(" ").to_s.yellow
      puts "#{" Local Variables: ".white}#{local_variables.join(" ").to_s.yellow}\n"
      
      puts "\n   #{path}".white + " #{lineno}".yellow
      puts "   Params: ".white + "#{params}".white if params
      puts "   Return Value: ".white + "#{return_value}".white if return_value
      puts "   Exception: ".white + "#{exception}".white if exception
      
    end

    def trace_menu
      create_menu(@actions)
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
      @attrs[method_id]
    end

    def defined_class
      @attrs[:defined_class]
    end

    def binding
      @attrs[:binding]
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
      binding.local_variables.each {|var| @local_variables[var] = binding.local_variable_get(var)}
    end

    def instance_variables
      @instance_variables ||= {}
      binding.instance_variables.each {|var| @instance_variables[var] = binding.instance_variable_get(var)}
    end

  end
end

# frozen_string_literal: true

module Bugzilla
  class Tracer
    class Trace

      attr_accessor :itself, :args, :object_id, :instance_variables,
                    :path, :lineno, :method_id, :defined_class, :return_value,
                    :raised_exception, :local_variables, :event

      def initialize(tracepoint)
        @itself = tracepoint.binding.eval('self')
        @method_id = tracepoint.method_id
        @args = extract_arguments(tracepoint)
        @object_id = @itself.object_id

        @event = tracepoint.event
        @path = tracepoint.path
        @lineno = tracepoint.lineno
        @defined_class = tracepoint.defined_class
        @return_value = tracepoint.return_value if tracepoint.event == :return
        @raised_exception = tracepoint.raised_exception if tracepoint.event == :raise

        @instance_variables = extract_instance_vars
        @local_variables = extract_local_vars
      end

      def to_s
        "#{event} #{path}:#{lineno} #{method_id} #{args}"
      end

      def extract_arguments(trace)
        param_names = trace.parameters.map(&:last)
        return [] if param_names.empty?

        param_names.map { |n| [n, trace.binding.eval(n.to_s)] }.to_h
      end

      def extract_instance_vars
        itself.instance_variables.map do |var|
          { "#{var}": itself.instance_variable_get(var) }
        end
      end

      def extract_local_vars
        # binding.pry if method_id == :hello_word && event == :return
        itself.send(:local_variables).map do |var|
          { "#{var}": itself.local_variable_get(var) }
        end
      end

      def source_code(include_type: false)
        # include_type ? type = itself.class.class == Class ? "class" : "module" : ""
        # context = "\n#{type} #{defined_class.to_s.capitalize}\n\n".yellow
        # context = "#{event}".blue + "#{defined_class.to_s}:#{path}#{lineno}\n"
        context = ""
        source = get_method.source

        eval_method_source(source)
        "#{context}#{CodeRay.scan(source, :ruby).term}\n"
      end

      def eval_method_source(source_code)
        source_code = source_code.split("\n")[1..-2].join("\n")

        itself.send(:eval, source_code)
      end

      def method_source_location
        get_method.source_location
      end

      def get_method
        itself.method(method_id)
      end
    end
  end
end

# frozen_string_literal: true

module Bugzilla
  class Tracer
    class Trace

      attr_accessor :itself, :args, :object_id, :instance_variables,
                    :path, :lineno, :method_id, :defined_class, :return_value,
                    :raised_exception, :local_variables, :event, :its_binding

      def initialize(tracepoint)
        @itself = tracepoint.binding.eval('self')
        @its_binding = tracepoint.binding
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
        param_names = trace.parameters.map(&:last).reject { |p| excluded_args.any?(p) }
        return [] if param_names.empty?

        param_names.map { |n| [n, trace.binding.eval(n.to_s)] }.to_h
      end

      def extract_instance_vars
        itself.instance_variables.map do |var|
          { "#{var}": itself.instance_variable_get(var) }
        end
      end

      def extract_local_vars
        # TODO
        []
      end

      def source_code(include_type: false)
        source = get_method.source

        res = eval_method_source(source)
        "#{CodeRay.scan(res, :ruby).term}\n"
      end

      def eval_method_source(source_code)
        res = []
        line1 = source_code.split("\n").first
        last_line = source_code.split("\n").last
        source_code.split("\n")[1..-2].each do |line|
          begin
            val = its_binding.eval(line)
            spaces = line.length >= 80 ? "   " : " " * (80 - line.length)
            res << (val ? line + spaces + "#=> #{val}" : line)
          rescue
            next
          rescue Exception # rubocop:disable Lint/RescueException
            res << line
          end
        end.join("\n")

        [line1, res, last_line].join("\n")
      end

      def run_method(method, **args)
        its_binding.send(method, **args)
      end

      def method_source_location
        get_method.source_location
      end

      def get_method
        itself.method(method_id)
      end

      def excluded_args
        %i[* ** &]
      end
    end
  end
end

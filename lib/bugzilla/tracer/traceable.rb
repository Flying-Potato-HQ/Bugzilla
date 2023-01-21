# frozen_string_literal: true

module Bugzilla
  class Tracer
    class Traceable

      # Creates a new Traceable object, it excepts to be passed a TracePoint
      # @param [TracePoint] trace_point The arguments passed
      def initialize(trace_point)
        raise ArgumentError, "Expected argument to be a TracePoint, got #{trace_point.class}" unless trace_point.is_a?(TracePoint)

        @attrs = build_attrs(trace_point)
        @args = extract_arguments(trace_point)
        @locals = extract_locals(trace_point)
        @instance_vars = extract_instance(trace_point)
      end

      def path
        @attrs[:path]
      end


      private

      def build_attrs(trace_point)
        attrs = {
          event: trace_point.event,
          lineno: trace_point.lineno,
          path: trace_point.path,
          method_id: trace_point.method_id,
          defined_class: trace_point.defined_class,
          cached_binding: trace_point.binding
        }

        attrs.merge!(params: trace_point.parameters) if trace_point.event == :call
        attrs.merge!(return_value: trace_point.return_value) if trace_point.event == :return
        attrs.merge!(exception: trace_point.raised_exception) if trace_point.event == :raise

        attrs
      end

      def extract_arguments(trace)
        param_names = trace.parameters.map(&:last)
        param_names.map { |n| [n, trace.binding.eval(n.to_s)] }.to_h
      end

      def extract_locals(trace)
        local_names = trace.binding.local_variables
        local_names.map { |n|
          [n, trace.binding.local_variable_get(n)]
        }.to_h
      end

      def extract_instance(trace)
        instance_names = trace.binding.eval("self").instance_variables
        instance_names.map { |n|
          [n, trace.binding.eval("self").instance_variable_get(n)]
        }.to_h
      end
    end
  end
end


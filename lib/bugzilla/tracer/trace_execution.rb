# frozen_string_literal: true

module Bugzilla
  class Tracer
    class TraceExecution
      attr_accessor :executions, :events
      def initialize(**args)
        @events = []
        @trace = nil
        @trace_complete = false
      end

      def perform(&block)
        raise ArgumentError, "Block required" unless block_given?

        5 / 0

        @trace = TracePoint.new(:call, :return) do |tp|
          next if tp.defined_class.to_s.in?(["Pry", "Bugzilla"])

          # @events.shift if @events.size > 100
          @events << Traceable.new(tp)
        end

        @trace.enable(&block)
        @trace_complete = true

        self
      end

      def done?
        @trace_complete
      end

      def events_by_event(event)
        raise ArgumentError, INVALID_EVENT_MESSAGE unless valid_events.include?(event)

        @events.select {|e| e.event == event }
      end

      def events_by_class(klass)
        klass = klass.to_s
        @events.select {|e| e.defined_class.to_s == klass }
      end

      def where_attr(attr, value, comparison = :==)
        @events.select {|e| e.send(attr).send(comparison, value) }
      end

      def where_attr_not(attr, value, comparison = :==)
        @events.select {|e| !e.send(attr).send(comparison, value) }
      end

      def where_attr_in(attr, values, comparison = :==)
        @events.select {|e| values.include?(e.send(attr).send(comparison)) }
      end

      def where_attr_present(attr)
        @events.select {|e| e.send(attr)&.present? }
      end

      def has_instance_var?(var_name)
        var_name = var_name + "@" unless var_name.start_with?("@")
        var_name = var_name.to_sym

        @events.select {|e| e.instance_vars.keys.include?(var_name) }
      end

      def summarise_events
        @events.map(&:event).tally
      end

      def summarise_classes
        @events.map(&:defined_class).tally
      end

      def summarise_methods
        @events.map(&:method_id).tally
      end

      def raise_events
        @events.select {|e| e.event == :raise }
      end

      def sequence_overview
        last_event = { Calls: []}

        res = []
        @events.each do |e|
          next unless e.event == :call

          action = "#{e.defined_class}"

          if last_event[:Action] != action
            res << last_event if last_event

            last_event = { Action: action, Count: 1, Calls: [
              "#{e.method_id}: #{e.lineno}"
            ] }
          else
            last_event[:Count] += 1
            loc = last_event[:Calls] << "#{e.method_id}:#{e.lineno}"

            unless loc.present?
              loc = { Count: 1 }
              last_event[:Calls]["#{e.method_id}:#{e.lineno}"][:Count] += 1
            end
          end
        end
        res
      end

      private

      def valid_events
        VALID_EVENTS
      end

      VALID_EVENTS = %i[call return raise c_call c_return c_raise b_call
           b_return thread_begin thread_end fiber_switch].freeze
      INVALID_EVENT_MESSAGE = "Invalid event, valid options include #{VALID_EVENTS.join(", ")}".freeze
    end
  end
end



# frozen_string_literal: true

module Bugzilla
  class Tracer
    class TraceExecution < Tracer



      def events_by_event(event)
        raise ArgumentError, INVALID_EVENT_MESSAGE unless valid_events.include?(event)

        @events.select {|e| e.event == event }
      end

      def events_by_class(klass)
        klass = klass.to_s
        @events.select {|e| e.defined_class.to_s == klass }
      end



      def has_instance_var?(var_name)
        var_name = var_name + "@" unless var_name.start_with?("@")
        var_name = var_name.to_sym

        @events.select {|e| e.instance_vars.keys.include?(var_name) }
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



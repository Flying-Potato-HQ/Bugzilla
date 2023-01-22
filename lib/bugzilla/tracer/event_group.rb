# frozen_string_literal: true

class Traceable
  class EventGroup
    extend Attributable
    include Enumerable

    def initialize(events)
      events = [events] unless events.is_a?(Array)
      @events = events
      @action = event.caller_location
    end

    def <<(event)
      @events << event
    end

    def locations
      @events.map(&:caller_location)
    end

    def where(**args)
      @events.select do |event|
        args.all? do |key, value|
          event.send(key) == value
        end
      end
    end

    def where_not(**args)
      @events.reject do |event|
        args.all? do |key, value|
          event.send(key) == value
        end
      end
    end

    def has_instance_var?(var_name)
      @events.any? do |event|
        event.has_instance_var?(var_name)
      end
    end

    def has_local_var?(var_name)
      @events.any? do |event|
        event.has_local_var?(var_name)
      end
    end

    def count
      @events.count
    end

    def each
      @events.each { |item| yield item }
    end

    def sequence_overview

    end
  end
end


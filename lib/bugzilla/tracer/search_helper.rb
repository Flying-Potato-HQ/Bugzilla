module Bugzilla
  module SearchHelper
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def where(**args)
        traces.select do |trace|
          args.all? { |key, value|
            trace.send(key) == value
          }
        end || nil
      end

      def where_any(**args)
        traces.select do |trace|
          args.any? { |key, value|
            trace.send(key) == value
          }
        end || nil
      end

      def where_not(**args)
        traces.select do |trace|
          args.none? { |key, value|
            trace.send(key) == value
          }
        end || nil
      end
    end
  end
end

# frozen_string_literal: true

module Bugzilla
  class Tracer
    class Config
      extend Attributable

      # @return [Hooks]
      attribute :hooks

      # @return [Boolean]
      attribute :verbose

      # @return [Boolean]
      attribute :debug

      # @return [Integer]
      attribute :max_stack_depth

      def initialize(**args)
        # TODO: Load defaults from defaults.yaml

        merge!(
          debug: true,
          max_stack_depth: 100
        )
      end

      def merge!(config_hash)
        config_hash.each { |attr, value| __send__("#{attr}=", value) }
        self
      end

      def merge(config_hash)
        dup.merge!(config_hash)
      end

      def []=(attr, value)
        @custom_attrs[attr.to_s] = Config::Value.new(value)
      end

      def [](attr)
        @custom_attrs[attr.to_s].call
      end

      def method_missing(method_name, *args, &block)
        if method_name.to_s.end_with?("=")
          instance_variable_set("@#{method_name.to_s[0..-2]}", args.first)
        else
          instance_variable_get("@#{method_name}")
        end
      end

      def respond_to_missing?(method_name, include_all = false)
        instance_variable_defined?("@#{method_name}")
      end
    end
  end
end
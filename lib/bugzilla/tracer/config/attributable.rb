# frozen_string_literal: true

module Bugzilla

  # @api private

  class Tracer
    class Config
      # Attributable provides the ability to create "attribute"
      # accessors. Attribute accessors create a standard "attr_writer" and a
      # customised "attr_reader". This reader is Proc-aware (lazy).
      #
      # @api private
      module Attributable
        def attribute(attr_name)
          @attributes = [] unless defined?(@attributes)
          @attributes << attr_name
          define_method(attr_name) do
            value = ::Config::Value.new(instance_variable_get("@#{attr_name}"))
            # value = ::Config::Value.new(instance_variable_get("@attributes")[attr_name])
            value.call
          end

          attr_writer(attr_name)
        end

        def attributes(*attr_names)
          attr_names.each { |attr_name| attribute(attr_name) }
        end
      end
    end
  end
end

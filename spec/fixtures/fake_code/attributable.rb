# frozen_string_literal: true

module Attributable
  def attribute(attr_name)
    define_method(attr_name) do
      value = Value.new(instance_variable_get("@#{attr_name}"))
      value.call
    end

    attr_writer(attr_name)
  end

  def singleton_attribute(attr_name, value = nil)
    define_singleton_method(attr_name) do
      value = Value.new(instance_variable_get("@#{attr_name}"))
      value.call
    end

    define_singleton_method("#{attr_name}=") do |value|
      instance_variable_set("@#{attr_name}", value)
    end

    send("#{attr_name}=", value) if value
  end
end

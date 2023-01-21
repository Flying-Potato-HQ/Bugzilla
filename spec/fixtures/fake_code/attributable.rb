# frozen_string_literal: true

module Attributable
  def attribute(attr_name)
    define_method(attr_name) do
      value = Value.new(instance_variable_get("@#{attr_name}"))
      value.call
    end

    attr_writer(attr_name)
  end
end

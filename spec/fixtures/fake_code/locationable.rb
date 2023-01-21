# frozen_string_literal: true

module Locationable
  def location(loc_state)
    @location ||= {}

    define_method(loc_state) do
      value = Value.new(instance_variable_get("@location[#{loc_state}]"))
      value.call
    end
  end
end

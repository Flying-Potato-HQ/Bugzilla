# frozen_string_literal: true

module Statable
  def state(state_name)
    define_method(state_name) do
      value = Value.new(instance_variable_get("@#{state_name}"))
      value.call
    end

    attr_writer(state_name)
  end
end

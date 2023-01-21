# frozen_string_literal: true

class Value
  def initialize(value)
    @value = value
  end

  def call
    @value
  end
end

# frozen_string_literal: true


class Action
  def initialize(action_type, target, &block)
    @action_type = action_type
    @target = target
    @block = block
  end

  def valid_actors
    [:self, :other]
  end
end

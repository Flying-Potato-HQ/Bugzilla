# frozen_string_literal: true

module Actionable
  def valid_actions
    @valid_actions ||= []
  end

  def act!(action, *args)
    self.modify_stamina(-1)
    self.modify_hunger(1)
    self.modify_thirst(1)

    log_action(action, :args)
    action = action.to_sym

    raise ArgumentError.new("Invalid action: #{action}") unless valid_actions.include?(action)
    ACTIONS[action].call(self)
  end

  ACTIONS = {
    eat: ->(amount) { self.modify_hunger(-amount) },
    drink: ->(amount) { self.modify_thirst(-amount) },
    rest: lambda { |amount, duration|
      self.modify_stamina(amount)
      self.state_ends_at = turn + duration
    },
    sleep: ->(amount) { self.modify_stamina(amount) },
    run: ->(amount) { self.modify_stamina(-amount) },
    walk: ->(amount) { self.modify_stamina(-amount) },
    swim: ->(amount) { self.modify_stamina(-amount) },
    climb: ->(amount) { self.modify_stamina(-amount) },
    jump: ->(amount) { actor.modify_stamina(-amount) },
    meow: ->(actor) { self.meow }
  }.freeze

  CORE_ACTIONS = [:eat, :drink, :rest, :sleep]
end

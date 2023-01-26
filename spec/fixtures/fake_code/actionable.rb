# frozen_string_literal: true

module Actionable
  def valid_actions
    @valid_actions ||= []
  end

  def act!(action, itself, amount: 1, duration: 0)
    itself.modify_stamina(-1)
    itself.modify_hunger(1)
    itself.modify_thirst(1)

    log_action(action, :args)
    action = action.to_sym

    raise ArgumentError.new("Invalid action: #{action}") unless valid_actions.include?(action)
    ACTIONS[action].call(itself, amount, duration)
  end

  ACTIONS = {
    eat: ->(itself, amount, duration) { itself.eat; itself.modify_hunger(-amount) },
    drink: ->(itself, amount, duration) { itself.eat; itself.modify_thirst(-amount) },
    sleep: ->(itself, amount, duration) { itself.sleep; itself.modify_stamina(amount) },
    run: ->(itself, amount, duration) { itself.run; itself.modify_stamina(-amount) },
    walk: ->(itself, amount, duration) { itself.walk; itself.modify_stamina(-amount) },
    swim: ->(itself, amount, duration) { itself.swim; itself.modify_stamina(-amount) },
    climb: ->(itself, amount, duration) { itself.climb; itself.modify_stamina(-amount) },
    jump: ->(itself, amount, duration) { itself.jump; itself.modify_stamina(-amount) },
    meow: ->(itself, amount, duration) { itself.meow },

    rest: lambda { |itself, amount, duration|
      itself.modify_stamina(amount)
    }
  }.freeze

  CORE_ACTIONS = [:eat, :drink, :rest, :sleep]
end

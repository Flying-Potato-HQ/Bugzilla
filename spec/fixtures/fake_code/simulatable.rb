# frozen_string_literal: true

class Simulatable
  extend Attributable
  include Actionable

  attribute :turn_born
  attribute :turn_died
  attribute :actions_taken
  attribute :current_state

  attribute :state_ends_at
  attribute :state_interuptable

  attribute :active # false if dead

  attr_accessor :actions_taken, :turn_born, :turn_died, :current_state,
                :state_ends_at, :state_interuptable, :active
  def initialize(**args)
    @turn_born = args[:turn_born]
    @turn_died = args[:turn_died]
  end

  def log_action(action, *args)
    @actions_taken ||= []
    @actions_taken << { action: action, args: args }
  end

  def random_action!
    act!(*self.class::VALID_ACTIONS.sample, self)
  end
end

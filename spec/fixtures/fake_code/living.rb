# frozen_string_literal: true

module Living
  extend Attributable
  extend Actionable

  attribute :health
  attribute :stamina
  attribute :hunger
  attribute :thirst

  def modify_hp(amount)
    self.health += amount
  end

  def modify_stamina(amount)
    self.stamina += amount
  end

  def modify_hunger(amount)
    self.hunger += amount
  end

  def modify_thirst(amount)
    self.thirst += amount
  end
end

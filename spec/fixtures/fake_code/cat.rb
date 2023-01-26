# frozen_string_literal: true

class Cat < Animal


  def initialize(**attrs)
    super
    merge!(default_attrs.merge(attrs))
  end

  def be_cute
    puts "#{self.name} is being cute"
  end

  def meow
    puts "#{self.name} meows contentedly"
  end

  def default_attrs
    {
      breed: "Ragdoll",
      likes_water: true,
      loves_tuna: true,
    }
  end

  def valid_actions
    VALID_ACTIONS
  end

  VALID_ACTIONS = Actionable::CORE_ACTIONS + [
    :jump, :climb, :meow, :run, :walk
  ]

end

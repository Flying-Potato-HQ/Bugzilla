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

  def wag_tail
    puts "#{self.name} wags its tail"
  end

  def default_attrs
    {
      breed: "Kelpie",
      likes_water: true,
      loves_walks: true,
      favourite_food: "All!"
    }
  end

  def valid_actions
    VALID_ACTIONS
  end

  VALID_ACTIONS = Actionable::CORE_ACTIONS + [
    :jump, :climb, :meow, :run, :walk
  ]

end

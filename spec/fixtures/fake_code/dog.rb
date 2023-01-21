# frozen_string_literal: true

class Dog < Animal


  def initialize(**attrs)
    super
    merge!(default_attrs.merge(attrs))
  end

  def be_cute
    puts "#{self.name} is being cute"
  end

  def bark
    puts "#{self.name} barks at the neighbour's cat"
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
end

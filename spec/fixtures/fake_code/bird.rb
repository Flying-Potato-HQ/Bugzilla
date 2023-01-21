# frozen_string_literal: true

class Bird < Animal

  attribute :max_altitude
  attribute :current_altitude
  attribute :current_vertical_speed
  attribute :current_horizontal_speed

  attribute :is_flying
  attribute :is_chirping

  def initialize(**attrs)
    super
    merge!(default_attrs.merge(attrs))
  end

  def fly
    if is_flying
      puts "#{self.name} continues to fly"
    else
      puts "#{self.name} starts to fly"
      self.is_flying = true
    end
  end

  def land
    if is_flying
      puts "#{self.name} lands"
      self.is_flying = false
    else
      puts "#{self.name} is already on the ground"
    end
  end

  def sleep
    if is_sleeping
      puts "#{self.name} is already sleeping"
    else
      puts "#{self.name} falls asleep"
      self.is_sleeping = true
    end
  end

  def chirp
    puts "#{self.name} chirps"
  end

  def eat
    puts "#{self.name} eats a worm"
  end

  def default_attrs
    {
      max_altitude: 100,
      current_altitude: 0,
      current_vertical_speed: 0,
      current_horizontal_speed: 0,
      is_flying: false
    }
  end
end

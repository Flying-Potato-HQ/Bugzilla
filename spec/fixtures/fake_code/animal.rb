# frozen_string_literal: true

class Animal
  extend Attributable
  extend Statable
  extend Locationable

  attribute :name
  attribute :age
  attribute :weight
  attribute :height
  attribute :color
  attribute :current_speed

  location :current_location
  location :current_direction

  state :is_sleeping
  state :is_eating
  state :is_drinking

  def initialize(**attrs)
    merge!(
      default_attrs.merge(attrs)
    )
  end

  def eat
    puts "#{self.name} eats"
  end

  def merge!(config_hash)
    config_hash.each { |attr, value| __send__("#{attr}=", value) }
    self
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.end_with?("=")
      instance_variable_set("@#{method_name.to_s[0..-2]}", args.first)
    else
      instance_variable_get("@#{method_name}")
    end
  end

  def respond_to_missing?(method_name, include_all = false)
    instance_variable_defined?("@#{method_name}")
  end
  
  private
  
  def default_attrs
    {
      name: "Animal #{rand(100)}",
      current_speed: 0
    }
  end

end

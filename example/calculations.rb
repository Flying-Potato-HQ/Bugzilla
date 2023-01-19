class Calculations
  def initialize(**args)
    args.each do |k, v|
      next if v.nil?
      value = multiply_for_no_reason(v)
      value = divide_for_no_reason(value)
      value = minus_numbers(value)
      value = add_numbers(value)

      instance_variable_set("@#{k}", value)
    end

  end

  def multiply_for_no_reason(input)
    input * 3.14159
  end

  def divide_for_no_reason(input)
    input / 3.14159
  end

  def minus_numbers(input)
    input - 4214
  end

  def add_numbers(input)
    input + 12421
  end
end
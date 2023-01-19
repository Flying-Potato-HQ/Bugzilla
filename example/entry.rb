require_relative "calculations"
module Entry
  def calculate_thing(**args)
    Calculations.new(**args)
  end
end

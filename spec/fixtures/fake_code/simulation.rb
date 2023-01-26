# frozen_string_literal: true

class Simulation
  include Attributable

  attr_accessor :start_config, :log, :state
  # attribute :car
  def initialize(**args)
    raise ArgumentError unless args.keys.all? { |k| VALID_ARGS.include?(k) }

    @start_config = {}
    @log = []

    @state = initial_state
    args.each do |k, v|
      @start_config[k] = v
    end
  end

  def prepare
    @start_config[:cats].times do
      @state[:cats] << Cat.new(
        turn_born: @state[:turn], health: 100,
        stamina: 100, hunger: 0, thirst: 0
      )
    end

    @start_config[:dogs].times do
      @state[:dogs] << Dog.new(
        turn_born: @state[:turn], health: 100,
        stamina: 100, hunger: 0, thirst: 0
      )
    end

    @start_config[:birds].times do
      @state[:birds] << Bird.new(
        turn_born: @state[:turn], health: 100,
        stamina: 100, hunger: 0, thirst: 0
      )
    end

    puts "Cats: #{@state[:cats].count}"
  end

  def simulate!
    while @state[:turn] < @state[:run_for]
      run_turn!
      @state[:turn] += 1
    end
  end

  def run_turn!
    @turn_log = {}
    @state[:cats].each do |cat|
      cat.random_action!
    end
  end

  def reset_state
    @state = initial_state
  end

  private

  def initial_state
    {
      turn: 0,
      animals: [],
      dogs: [],
      cats: [],
      birds: [],
      run_for: 100
    }
  end



  private

  VALID_ARGS = %i[animals dogs birds cats run_for].freeze
end

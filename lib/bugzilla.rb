# frozen_string_literal: true

# Core
require "awesome_print"

require "bugzilla/version"

require "bugzilla/helpers/attributable"

require "bugzilla/tracer/config//attributable"
require "bugzilla/tracer/config/lazy_value"
require "bugzilla/tracer/config/memoized_value"
require "bugzilla/tracer/config/value"
require "bugzilla/tracer/config"
require "bugzilla/tracer/event_group"

require "bugzilla/tracer"
require "bugzilla/exceptions"
require "bugzilla/hooks"

# Tracer Module
require "bugzilla/tracer/traceable"
require "bugzilla/tracer/trace_execution"

require "bugzilla/helpers/overrides"

def fake_trace!
  tracer = Tracer.new { birds_life }.trace do
    birds_life
  end
  tracer
end

def thing!
  sim = Simulation.new(dogs: 12, cats: 4, birds: 2)
  sim.prepare
  sim.run_turn!
end

def trace!
  tracer = Tracer.new { birds_life }.trace do
    sim = Simulation.new(dogs: 12, cats: 4, birds: 2)
    sim.prepare
  end

  tracer
end

def load_fixtures
  require_relative "../spec/fixtures/fake_code/actionable"

  require_relative "../spec/fixtures/fake_code/simulatable"
  require_relative "../spec/fixtures/fake_code/value"
  require_relative "../spec/fixtures/fake_code/attributable"
  require_relative "../spec/fixtures/fake_code/statable"
  require_relative "../spec/fixtures/fake_code/locationable"
  require_relative "../spec/fixtures/fake_code/action"
  require_relative "../spec/fixtures/fake_code/predatorable"
  require_relative "../spec/fixtures/fake_code/animal"
  require_relative "../spec/fixtures/fake_code/living"
  require_relative "../spec/fixtures/fake_code/dog"
  require_relative "../spec/fixtures/fake_code/bird"
  require_relative "../spec/fixtures/fake_code/cat"

  require_relative "../spec/fixtures/fake_code/simulation"
end

load_fixtures # add condition?

def birds_life
  bird = Bird.new(name: "Tweety", age: 2, wingspan: 10, color: "yellow and blue", favourite_food: "seeds, and French cheese")
  bird.fly
  bird.eat
  bird.sleep

  dog = Dog.new(name: "Korra")
  dog.bark
  dog.wag_tail
  dog.be_cute
end
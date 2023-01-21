# frozen_string_literal: true

# Core
require "bugzilla/version"

require "bugzilla/tracer/config//attributable"
require "bugzilla/tracer/config/lazy_value"
require "bugzilla/tracer/config/memoized_value"
require "bugzilla/tracer/config/value"
require "bugzilla/tracer/config"

require "bugzilla/tracer"
require "bugzilla/exceptions"
require "bugzilla/hooks"

# Tracer Module
require "bugzilla/tracer/traceable"
require "bugzilla/tracer/trace_execution"

require "bugzilla/helpers/string"

def fake_trace!
  load_fixtures # add condition?
  tracer = Tracer.new { birds_life }.trace do
    birds_life
  end

  puts "\n\n Count: #{tracer.executions.last.events.count}"
  tracer
end

def load_fixtures
  require_relative "../spec/fixtures/fake_code/value"
  require_relative "../spec/fixtures/fake_code/attributable"
  require_relative "../spec/fixtures/fake_code/statable"
  require_relative "../spec/fixtures/fake_code/locationable"
  require_relative "../spec/fixtures/fake_code/flyable"
  require_relative "../spec/fixtures/fake_code/animal"
  require_relative "../spec/fixtures/fake_code/dog"
  require_relative "../spec/fixtures/fake_code/bird"
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
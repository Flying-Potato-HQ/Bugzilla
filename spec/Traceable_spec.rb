# frozen_string_literal: true

RSpec.describe Bugzilla do

  describe "Tracer::Traceable" do
    @tracer = Tracer.new { @hello_world = "Hello World"; puts @hello_world }

    it "can list instance variables of state" do
      expect(@tracer.config.max_stack_depth).to eq(100)
    end

    it "test" do
      res = fake_trace!
      count = res.executions.last.events.count

      #expect count > 20
      expect(count).to be > 20
    end

    it "test 2" do
      sim = Simulation.new(dogs: 12, cats: 4, birds: 2)
      sim.prepare
    end
  end

  def run_sim!
    @sim = Simulation.new(dogs: 3, cats: 4, birds: 2)
    @sim.prepare
    @sim.run_sim!
  end
end

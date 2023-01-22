# frozen_string_literal: true

RSpec.describe Bugzilla do

  describe "Tracer::Config" do
    before do
      @tracer = Tracer.new { puts "Hello World" }
    end


    it "has a max_stack_depth" do
      expect(@tracer.config.max_stack_depth).to eq(100)
    end

    it "test" do
      res = fake_trace!
      count = res.executions.last.events.count

      #expect count > 20
      expect(count).to be > 20
    end

    it "Should properly log events" do
      results = trace do
        sim = Simulation.new(dogs: 12, cats: 4, birds: 2)
        sim.prepare
      end

      expect(results.events.count).to be > 100
    end

    describe "It should be possible get SearchResults on the response" do
      before do
        @results = trace! do
          sim = Simulation.new(dogs: 12, cats: 4, birds: 2)
          sim.prepare
        end
      end

      it "SearchResults: Returns SearchResults when querying trace results" do
        output = @results.with_ivar("@start_config")

        expect(output.class).to eq(SearchResults)
      end


      it "Can retrieve a tally of events" do
        output = @results.tally_by(:event)

        # get memory address of the output
        output.object_id

        expect(output[:call]).to be > 20
        expect(output[:return]).to be > 20
      end

      it "Can retrieve a tally of defined_class" do
        output = @results.tally_by(:defined_class)

        expect(output[Simulation]).to be > 3
        expect(output[Array]).to be > 3
        expect(output[Cat]).to be > 3
        expect(output[Animal]).to be > 3
      end

      it "Can retrieve results with matching instance var" do
        original_output = @results.events.count
        output = @results.with_ivar("@start_config")

        expect(output.count).to be > 3
        expect(output.count).to be < original_output
      end
    end

  end
end

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
  end
end

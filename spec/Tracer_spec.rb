# frozen_string_literal: true

RSpec.describe Bugzilla do

  # TODO: Write a proper test suite
  describe "Tracer" do
    before do
      @tracer = Tracer.perform! do
        puts "Hello world"
      end
    end

    it "should have a version number" do
      expect(Bugzilla::VERSION).not_to be nil
    end

    it "should have an array of traces" do
      expect(@tracer.traces).to be_a(Array)
    end

    it "should have a count of ignored traces" do
      expect(@tracer.ignored_traces_count).to be_a(Integer)
    end
  end

  describe "Tracer::Trace" do

  end

  describe "Tracer::Config" do
    before do
      @tracer = Tracer.new
    end

    it "should have a config" do
      expect(@tracer.config).to be_a(Tracer::Config)
    end

    it "should have a backtrace cleaner" do
      expect(@tracer.backtrace_cleaner).to be_a(ActiveSupport::BacktraceCleaner)
    end

    it "should have a colourize boolean" do
      expect(@tracer.colorize?).to be(true).or be(false)
    end
  end
end

# frozen_string_literal: true

module Bugzilla
  class SearchResults < Tracer
    include Handlers

    def initialize(events)
      super
      @events = events
    end
  end
end

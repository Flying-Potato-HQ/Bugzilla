# frozen_string_literal: true

# Core
require "active_support/core_ext/module/delegation"
require "awesome_print"
require "pry"
require "yaml"

require "bugzilla/version"

require "bugzilla/utilities/backtrace_cleaner"

require "bugzilla/config"
require "bugzilla/values/attributable"
require "bugzilla/values/value"
require "bugzilla/tracer/config"
require "bugzilla/tracer/trace"
require "bugzilla/tracer"


module Bugzilla


  class << self
    Config.new
  end

  class << self

  end
end

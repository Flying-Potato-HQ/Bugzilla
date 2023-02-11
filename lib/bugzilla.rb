# frozen_string_literal: true

# Core
require "active_support/core_ext/module/delegation"
require "awesome_print"
require "pry"
require "yaml"

require "bugzilla/version"

require "bugzilla/utilities/backtrace_cleaner"
require "bugzilla/utilities/output_helper"

require "bugzilla/config"
require "bugzilla/tracer/config"
require "bugzilla/tracer/search_helper"
require "bugzilla/tracer/trace"
require "bugzilla/tracer"


module Bugzilla

  COLORS = {
    true => "38",
    blue: "34",
    light_red: "1;31",
    black: "30",
    purple: "35",
    light_green: "1;32",
    red: "31",
    cyan: "36",
    yellow: "1;33",
    green: "32",
    gray: "37",
    light_blue: "1;34",
    brown: "33",
    dark_gray: "1;30",
    light_purple: "1;35",
    white: "1;37",
    light_cyan: "1;36"
  }.freeze

end

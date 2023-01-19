# frozen_string_literal: true

module Formatter

  BLACKLISTED_LOCATIONS = %w[
    gems rubies middleware goldiloader application_controller prosopite backend/platform irb
      irb_binding /bin/rails:5 -e:1
  ].freeze

  TRUNC_PATH = [
    "/Users/samuelodonnell/.rvm/gems/ruby-3.2.0-preview3/gems/pry-0.14.1/lib/pry"
  ].freeze

  def full_clean_trace(traces)
    traces = clean_trace(traces)
    clean_paths(traces)
  end
  def clean_trace(traces)
    traces = traces.reject do |loc|
      BLACKLISTED_LOCATIONS.any? { |bl| loc.to_s.include?(bl) }
    end
  end

  def clean_paths(paths)
    paths = [paths] unless path.is_a?(Array)

    paths.map do |path|
      TRUNC_PATH.map do |rule|
        path = path.gsub(rule, "...")
      end
    end
  end

end

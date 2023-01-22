# frozen_string_literal: true

module CleanTrace
  def clean_trace(exception)
    res = exception.backtrace.reject do |trace|
      IGNORED_PATHS.any? { |path| trace.include?(path) }
    end

    puts "\n\n---- Backtrace ----\n\n".green

    res = res.map do |trace|
      trace = trace.split("/lib/").last
      CodeRay.scan(trace, :ruby).term
    end

    puts res
    puts "\n\n"
    ap exception.message
  end

  IGNORED_PATHS = %w[pry/pry_instance.rb pry/repl.rb pry/input_lock.rb pry/pry_class.rb].freeze
end

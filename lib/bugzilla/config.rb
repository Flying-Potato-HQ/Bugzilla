module Bugzilla
  class Config
    def initialize(**args)
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def load_defaults
      {
        is_rails: defined?(Rails),
        safe_mode: false
      }
    end
  end
end

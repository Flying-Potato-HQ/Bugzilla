module Bugzilla
  class Config
    def initialize(**args)
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

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

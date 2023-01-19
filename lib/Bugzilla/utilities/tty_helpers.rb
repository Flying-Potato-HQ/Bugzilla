# frozen_string_literal: true

module TTYHelpers
  def prompt
    TTY::Prompt.new
  end

  def await_input
    puts "Press any key to continue...".blueish
    gets
  end
end

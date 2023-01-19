# frozen_string_literal: true
require "tty-prompt"
require "tty-box"
require "tty-table"
module TTYHelpers
  def prompt
    TTY::Prompt.new
  end

  def await_input
    puts "Press any key to continue...".blueish
    gets
  end
end

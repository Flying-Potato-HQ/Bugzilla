# frozen_string_literal: true
require "tty-prompt"
require "tty-box"
require "tty-table"
require "tty-screen"

module TTYHelpers
  def prompt
    TTY::Prompt.new
  end

  def await_input
    puts "Press any key to continue...".blueish
    gets
  end

  def center_align(string, margin: 2)
    " " * ((TTY::Screen.width - string.length - margin) / 2) + string
  end

  def left_align(string, margin: 2)
    " " * margin + string
  end

  def right_align(string, margin: 2)
    " " * (TTY::Screen.width - string.length - margin) + string
  end

  def get_standardised_offset(array, offset: 2)
    # find the length of the longest element
    longest = array.map(&:length).max
    length = longest + offset
  end

  private

  def terminal_width
    TTY::Screen.width
  end

  def terminal_height
    TTY::Screen.height
  end

end

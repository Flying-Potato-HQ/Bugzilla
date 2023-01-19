require_relative './tty_helpers'

module Menu

  def create_menu(hash)
    system "clear"

    prompt.select("Select a line to inspect", per_page: 20) do |menu|
      hash.each do |text, proc|
        menu.choice text.to_s.yellow, lambda {
                                        puts proc.call
                                        await_input
                                        create_menu(hash)
                                      }
      end
      menu.choice "Back".white, -> {}
      menu.choice "Exit".red, -> { exit }
    end
  end

end
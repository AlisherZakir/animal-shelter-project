class Terminal
  def initialize
    @prompt = TTY::Prompt.new
  end
  def greeting
    puts "hello!"
    self
  end
  def clean
    system("clear && printf '\e[3J'")
    self
  end
  def ask_name
    @prompt.ask('What is your name?', default: ENV['USER'])
  end
  def show_menu
    choices = ["Show me all the pets", "Make a donation", "Adopt a pet", "Adopt a pet (for real)", "Show me pets nearby"]
    @prompt.select("What would you like to do?", choices)
    clean
  end
end

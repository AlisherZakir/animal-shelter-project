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
    choices = ["tables", "Make a donation", "Adopt a pet", "Adopt a pet (for real)", "Show me pets nearby", "log off"]
    @prompt.select("What would you like to do?", choices)
  end

  def tables
    choices = %w(Pet User Adoption)
    choose_vars(@prompt.select("Select database", choices))
  end

  def choose_vars(klass)
    choices = Module.const_get(klass).column_names
    columns = @prompt.multi_select("Select columns", choices)
    show_table(klass, *columns)
  end


  def show_table(klass, *arr)
    klass = Module.const_get(klass)
    if arr.empty?
      data = klass.all
      columns = data.column_names
    else
      data = klass.select(*arr)
      columns = arr
    end
    Table.new(columns, data).render
  end


  def self.run
    loop do
      cli = new
      puts "Sign up or login?"
      input = gets.chomp
      break if input == "Exit"

      loop do
        choice = cli.greeting.show_menu
        break if choice == "log off"
        cli.send(choice)
      end
    end
  end
end

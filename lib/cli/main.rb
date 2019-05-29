class Terminal


  def initialize
    @prompt = TTY::Prompt.new
    @user_access = ""
  end

  def greeting
    puts "Welcome"
    @prompt.yes?('Are you a new user?')
  end

  def signup
   first_name = @prompt.ask('What is your first name?')
   last_name = @prompt.ask('What is your last name?')
   post_code = @prompt.ask('What is your postcode?')
   age = @prompt.ask('How old are you?', convert: :int)
   password = @prompt.mask('Enter a password')
   @user = User.create(first_name: first_name, last_name: last_name, post_code: post_code,password: password, age: age)
   puts @user
   puts "Account Created!"
   false
  end


  def login
    first_name = @prompt.ask('What is your first name?')
    password = @prompt.mask("Please enter your password!")
    @user_access = User.find_by(first_name: first_name, password: password)
    !@user_access.nil?

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
      # puts "Sign up or login?"
      # input = gets.chomp
      # break if input == "Exit"
      loop do
        break if (cli.greeting ? cli.signup : cli.login)
      end

      loop do
        choice = cli.greeting.show_menu
        break if choice == "log off"
        cli.send(choice)
      end
    end
  end


  def make_donation
    valid = false
    show_pets
    amount = @prompt.ask('How much would you like to donate?') until amount.to_i != 0
    while !valid
      pet_name = @prompt.ask('Which pet do you want to help?')
      pet = Pet.find_by(name: pet_name)
      if pet
        valid = true
      end
    end
    donation = Donation.create(user_id: @user.id,pet_id: pet.id, amount: amount)
    puts donation
    puts "#{pet.name} recieved #{donation.amount}"
    self
  end



end

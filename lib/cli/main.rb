class Terminal

  def initialize
    @prompt = TTY::Prompt.new
  end
  def greeting
    puts "|.........................|"
    puts "|.........................|"
    puts "|.........................|"
    puts "|Welcome to the Pet World!|"
    puts "|.........................|"
    puts "|.........................|"
    puts "|.........................|"
    @prompt.yes?('Are you a new user?')
  end

  def signup
   password = ''
   confirm_password = '' 
  
   first_name = @prompt.ask('What is your first name?')
   last_name = @prompt.ask('What is your last name?')
   post_code = @prompt.ask('What is your postcode?')
   age = @prompt.ask('How old are you?', convert: :int)

   loop do
    password = @prompt.mask('Enter a password')
    confirm_password = @prompt.mask("Please confirm your password!")
    if password != confirm_password
      puts "Please, make sure your password and confirmation password are matching."
    end
    break if password == confirm_password
  end
  @user = User.create(first_name: first_name, last_name: last_name, post_code: post_code,password: password, age: age)
  puts @user
  puts "Account successfully created!"
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
    "Welcome #{@user_access.first_name}"
    @options = ["Show me all the pets", "Make a donation", "Adopt a pet", "Show me pets nearby", "Exit"]
    @option = @prompt.select("What would you like to do?", @options)
        if @option == @options[0]
          show_pets
        elsif @option == @options[1]
          make_donation
        elsif @option == @options[2]
          adopt_pet
        elsif @option == @options[3]
          adopt_pet_for_real
        elsif @option == @options[4]
          false
        end
    end

  

  def show_pets
    puts Pet.all.map {|pet| pet.name}
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

  def self.run
    cli = new
    cli.clean
    loop do
      break if (cli.greeting ? cli.signup : cli.login)
    end
    loop do
      break if cli.show_menu == false
    end
  end

  def adopt_pet
  end

  def show_pets_nearby
  end

end
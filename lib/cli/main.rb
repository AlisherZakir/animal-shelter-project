class Terminal


  def initialize
    @prompt = TTY::Prompt.new
    @user = User.all.first
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
   User.create(first_name: first_name, last_name: last_name, post_code: post_code,password: password, age: age)
   puts "Account Created!"
   false
  end


  def login
    first_name = @prompt.ask('What is your first name?')
    password = @prompt.mask("Please enter your password!")
    @user = User.find_by(first_name: first_name, password: password)
    !@user.nil?
  end

  def clean
    system("clear && printf '\e[3J'")
    self
  end


  def ask_name
    @prompt.ask('What is your name?', default: ENV['USER'])
  end


  def show_menu
    puts ""
    puts ""
    puts "Logged in as #{@user.full_name}"
    puts ""
    puts ""
    choices = ["tables", "make_donation", "adopt_a_pet", "Show me pets nearby", "log off"]
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
    # loop do
      cli = new
    #   # puts "Sign up or login?"
    #   # input = gets.chomp
    #   # break if input == "Exit"
    #   loop do
    #     break if (cli.greeting ? cli.signup : cli.login)
    #   end

      loop do
        choice = cli.show_menu
        break if choice == "log off"
        cli.send(choice)
      end
    # end
  end

  def get_correct_pet(prompt)
    pet = Pet.find_by(name: @prompt.ask(prompt)) until pet
    pet
  end


  def make_donation
    show_table("Pet", :name)
    settings = {user_id: @user.id, amount: 0}
    settings[:amount] = @prompt.ask('How much would you like to donate?').to_i until settings[:amount] != 0
    pet = get_correct_pet('Which pet do you want to help?')
    settings[:pet_id] = pet.id
    donation = Donation.create(settings)
    puts "#{pet.name} received $#{donation.amount}"
  end

  def adopt_a_pet
    show_table("Pet", :name)
    pet = get_correct_pet("Who would you like to adopt")
    Adoption.create(pet_id: pet.id, user_id: @user.id, adoption_date: Date.today)
    puts "#{pet.name} was succesfully adopted"
  end



end

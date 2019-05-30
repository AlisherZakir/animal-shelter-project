class Terminal

attr_reader :user

  def initialize
    @prompt = TTY::Prompt.new
    @user = User.all.first
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
    answers = @prompt.collect do
      key(:first_name).ask('What is your first name?')
      key(:last_name).ask('What is your last name?')
      key(:post_code).ask('What is your postcode?')
      key(:age).ask('How old are you?') do |q|
        q.validate(/^((?!\D).)*$/, "Please provide a number")
        q.required true
        q.in("0-99")
      end
      key(:password).mask('Enter a password')
    end
   password = ''
   confirm_password = ''

   loop do
    password = @prompt.mask('Enter a password')
    confirm_password = @prompt.mask("Please confirm your password!")
    if password != confirm_password
      puts "Please, make sure your password and confirmation password are matching."
    end
    break if password == confirm_password
  end
  User.create(answers)
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
    puts "Logged in as #{@user.name}"
    puts ""
    puts ""
    choices = ["tables", "make_donation", "adopt_a_pet", "table_update", "delete_record", "Show me pets nearby", "log off"]
    @prompt.select("What would you like to do?", choices)
  end

  def delete_record
    choices = %w(Pet User Adoption Shelter Donation)
    record = find_record(@prompt.select("Select database", choices))
    puts "#{record.name} was successfuly deleted"
    record.destroy
  end

  def table_update
    choices = %w(Pet User Adoption Shelter Donation)
    record = find_record(@prompt.select("Select database", choices))
    key = @prompt.select("Select attribute", record.attributes.keys)
    hash = {}
    hash[key] = @prompt.ask("Set a new value: ")
    record.update(hash)
    Table.new(record.attributes.keys, [record]).render
  end


  def find_record(klass)
    record = Module.const_get(klass).find_by(name: @prompt.ask("Enter name:")) until record
    record
  end

  def tables
    choices = %w(Pet User Adoption Shelter Donation)
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
      # puts "Sign up or login?"
      # input = gets.chomp
      # break if input == "Exit"
      # loop do
      #   break if (cli.greeting ? cli.signup : cli.login)
      # end

      puts "Welcome #{cli.user.first_name}"

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

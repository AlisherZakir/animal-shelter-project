class Terminal

  attr_reader :user

  def initialize
    @prompt = TTY::Prompt.new
    @user = User.all.last
  end

  def greeting    
puts '                      WELCOME TO THE PETWORLD APP                           '    
puts '                      /^--^\     /^--^\     /^--^\ '
puts '                      \____/     \____/     \____/ '
puts '                     /      \   /      \   /      \ '
puts '                    |        | |        | |        | '
puts '                     \__  __/   \__  __/   \__  __/ '
puts "|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|"
puts "| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |"
puts '########################/ /######\ \###########/ /#######################'
puts "| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |"
puts "|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|"
    @prompt.yes?('Are you a new user?') ? "signup" : "login"
  end

  def signup
    answers = ""
    loop do
      answers = @prompt.collect do
        %w(first_name last_name).each do |item|
          key(item).ask("What is your #{item.split("_").join(" ")}?") do |q|
            q.validate(/^((?!\d).)*$/)
            q.required true
          end
        end
        key(:location).ask('What is your location?')
        key(:age).ask('How old are you?') do |q|
          q.validate(/^((?!\D).)*$/, "Please provide a number")
          q.required true
          q.in("0-99")
        end
      end
      first, last = answers["first_name"], answers["last_name"]
      break if User.find_by(name: "#{first} #{last}").nil?
    end
    loop do
    password = @prompt.mask('Enter a password')
    confirm_password = @prompt.mask('Please confirm your password!')
    if password != confirm_password
      puts "Please, make sure your password and confirmation password are matching."
    end
      if password == confirm_password
        answers[:password] = password
        break
      end
    end
    User.create(answers)
    puts "Account Created!"
    "greeting"
end

  def login
    full_name = ''
    password = ''
    loop do
    full_name = @prompt.ask('What is your full name?')
    password = @prompt.mask("Please enter your password!")
    break if !(full_name.nil? || password.nil?)
    end
    @user = User.find_by(name: full_name)
    if !@user
      if @prompt.yes?("Sorry, but we can not find you in our record. Would you like to sign up?")
        "signup"
      end
    else
      "greeting"
    end

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
    choices = ["tables", "make_donation", "adopt_a_pet", "table_update", "delete_record", "show_me_pets_nearby", "show_my_pets", "log off"]
    @prompt.select("What would you like to do?", choices)
  end

  def delete_record
    choices = %w(Pet User Adoption Shelter Donation)
    record = find_record(@prompt.select("Select database", choices))
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
    @user = User.find_by(id: @user.id)
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
      cli = new
      loop do
        choice = cli.greeting
        break if choice == "logged_in"
        cli.send(choice)
      end

      puts "Welcome #{cli.user.first_name}"

      loop do
        choice = cli.show_menu
        break if choice == "log off"
        cli.send(choice)
      end
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


  def show_me_pets_nearby
    puts @user.first_name
    puts @user.location
    pets = Shelter.where(location: @user.location).map(&:pets).flatten
    Table.new(Pet.column_names, pets).render
  end

  def show_my_pets
    @user.pets
    Table.new(Pet.column_names, @user.pets).render
  end

end

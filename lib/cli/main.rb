class Terminal

  attr_reader :user

  def initialize
    @prompt = TTY::Prompt.new(track_history: false)
    @user = ''
  end

def banner
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
end

  def greeting
    @prompt.yes?('Are you a new user?') ? "signup" : "login"
  end

  def signup
    answers = @prompt.collect do
      %w(first_name last_name).each do |item|
        key(item).ask("What is your #{item.tr("_", " ")}?") do |q|
          q.validate(/^((?!\d).)*$/, "Please provide a valid")
          q.required true
        end
      end
      key(:location).ask('What is your location?', required: true)
      key(:age).ask('How old are you?') do |q|
        q.validate(/^((?!\D).)*$/, "Please provide a number")
        q.required true
        q.in("0-99")
      end
    end
    loop do
      answers[:username] = @prompt.ask("Please, create you username", required: true)
      break if !User.find_by(username: answers[:username])
    end
    loop do
    password = @prompt.mask('Enter a password', required: true)
    confirm_password = @prompt.mask('Please confirm your password!', required: true)
    if password != confirm_password
      @prompt.error("Please, make sure your password and confirmation password are matching.")
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
    username = @prompt.ask('What is your Username?') do |q|
      # q.validate(/^((?!\d).)*$/)
      q.required true
    end
    user = User.find_by(username: username)
    if user.nil?
      yes =  @prompt.yes?("Sorry, but we can not find you in our record. Would you like to sign up?")
      return yes ? "signup" : "login"
    end
    password = @prompt.mask("Please enter your password!", required: true)
    @user = User.find_by(username: username, password: password)
    @user.nil? ? (@prompt.error("password is incorrect"); "login") : (@prompt.ok("Access granted!"); "logged_in")
  end

  def clean
    system("clear && printf '\e[3J'")
    self
  end

  ##RUN THIS TO WORK##
  def self.run
    loop do
      cli = new
      choice = cli.greeting
      loop do
        break if choice == "logged_in"
        choice = cli.send(choice)
      end

      puts "Welcome #{cli.user.first_name}"

      choice = cli.show_menu

      loop do
        break if choice == "log off"
        choice = cli.send(choice)
      end

    end
  end


  def check_admin
    if @user.username == "admin"
      choices = ["tables",
        "table_update",
        "delete_record",
        "log off"]
    else
      choices = [{value: "show_all_pets", name: "Show me all pets"},
        {value: "show_all_shelters", name: "Show me all shelters"},
        {value: "make_donation", name: "Make a donation"},
        {value: "adopt_a_pet", name: "Adopt a pet"},
        {value: "show_me_pets_nearby", name: "Adoptable pets near me"},
        {value: 'show_my_pets', name: "Meet my pets"},
        "log off"]
      choices[4][:disabled] = "(there a no adoptable pets at your location)" if pets_near_me.empty?
      choices[5][:disabled] = "(you don't have any pets)" if @user.pets.empty?
    end
    choices
  end

##MAIN MENU##
  def show_menu
    clean
    banner
    puts ""
    puts ""
    puts "Logged in as #{@user.name}"
    puts "Adopted pets: #{@user.pets.map(&:name).join(", ")}"
    puts ""
    choices = check_admin
    # choices[6][:active_color] = :grey if @user.pets.empty?
    @prompt.select("What would you like to do?", choices)
  end


  ##MENU OPTIONS##
  def show_all_pets
    choose_vars("Pet")
  end

  def show_all_shelters
    choose_vars("Shelter")
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
    "show_menu"
  end

  def delete_record
    choices = %w(Pet User Adoption Shelter Donation)
    record = find_record(@prompt.select("Select database", choices))
    puts "#{record.name} was successfuly deleted"
    record.destroy
    @user = User.find_by(id: @user.id)
    "show_menu"
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
    "show_menu"
  end

  def make_donation
    show_table("Pet", :name)
    settings = {user_id: @user.id, amount: 0}
    settings[:amount] = @prompt.ask('How much would you like to donate?') do |q|
      q.required(:true)
      q.validate(/^((?!\D).)*$/, "Please provide a number")
    end
    pet = get_correct_pet('Which pet do you want to help?')
    settings[:pet_id] = pet.id
    donation = Donation.create(settings)
    puts "#{pet.name} received $#{donation.amount}"
    "show_menu"
  end

  def adopt_a_pet
    show_table("Pet", :name)
    pet = get_correct_pet("Who would you like to adopt")
    Adoption.create(pet_id: pet.id, user_id: @user.id, adoption_date: Date.today)
    puts "#{pet.name} was succesfully adopted"
    @user = User.find_by(id: @user.id)
    "show_menu"
  end

  def show_my_pets
    Table.new(Pet.column_names, @user.pets).render
    "show_menu"
  end

  def show_me_pets_nearby
    Table.new(Pet.column_names, pets_near_me).render
    "show_menu"
  end

  ##HELPER METHODS##
  def pets_near_me
    Shelter.where(location: @user.location).map(&:pets).flatten
  end

  def get_correct_pet(prompt)
    pet = Pet.find_by(name: @prompt.ask(prompt)) until pet
    pet
  end

  def find_record(klass)
    if %w(Pet User Shelter).include?(klass)
      record = Module.const_get(klass).find_by(name: @prompt.ask("Enter full name:", required: true)) until record
    else
      record = Module.const_get(klass).find_by(id: @prompt.ask("Enter id:", required: true)) until record
    end
    record
  end


  def tables
    choices = %w(Pet User Adoption Shelter Donation Menu)
    selection = @prompt.select("Select database", choices)
    choose_vars(selection) if selection != "Menu"
    "show_menu"
  end

  def choose_vars(klass)
    choices = Module.const_get(klass).column_names.dup
    choices.shift if @user.username != "admin"
    choices << {name: "Menu", value: "show_menu"}
    columns = @prompt.multi_select("Select columns", choices)
    return "show_menu" if columns.include?("show_menu")
    show_table(klass, *columns)
  end


end

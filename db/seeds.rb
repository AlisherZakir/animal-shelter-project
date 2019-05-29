require "date"

Terminal.new.clean

spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :classic, success_mark: '+')

spinner.auto_spin # Automatic animation with default interval

# remove prev data
# Rake::Task['db:drop'].invoke
# Rake::Task['db:migrate'].invoke
system("rake db:drop")
system("rake db:migrate")



15.times do
  User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        age: Faker::Number.number(2)
)
end

Dog = Faker::Creature::Dog

#Dogs
10.times do
  Pet.create(
        name: Dog.name,
        breed: Dog.breed,
        age: rand(16),
        sex: Dog.gender,
        size: Dog.size
  )
end

#Cats
Cat = Faker::Creature::Cat
10.times do
  Pet.create(
        name: Cat.name,
        breed: Cat.breed,
        size: Dog.size,
        sex: Dog.gender,
        age: rand(16)
  )
end

#adoptions

20.times do
  Adoption.create(
        user_id: User.all.sample.id,
        pet_id: Pet.all.sample.id,
        adoption_date: Date.new([2018,2019].sample, rand(12) + 1, rand(28)+1)
  )
end

spinner.success('Done!') # Stop animation

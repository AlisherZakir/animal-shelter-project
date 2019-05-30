require "date"

Terminal.new.clean

spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :classic, success_mark: '+')

spinner.auto_spin # Automatic animation with default interval

15.times do
User.create(
first_name: Faker::Name.first_name,
last_name: Faker::Name.last_name,
age: Faker::Number.number(2),
location: Faker::Address.city,
password: "easyone"
)
end
        
#         password: "12345"
# )
# end
#
# Dog = Faker::Creature::Dog
#
# #Shelters
# shelter_names = %w(Underdog ForeverAHome DogsLivesMatter GiveMeShelter PawPrints 4Legs TimeForChange)
#
# 7.times do
#   Shelter.create(
#             name: shelter_names.pop,
#             location: "London"
#   )
# end
#
# #Dogs
# shelter_ids = Shelter.all.map(&:id)
# 10.times do
#   Pet.create(
#         name: Dog.name,
#         breed: Dog.breed,
#         age: rand(16),
#         sex: Dog.gender,
#         size: Dog.size,
#         animal: "Dog",
#         shelter_id: shelter_ids.sample
#   )
# end
#
# #Cats
# Cat = Faker::Creature::Cat
# 10.times do
#   Pet.create(
#         name: Cat.name,
#         breed: Cat.breed,
#         size: Dog.size,
#         sex: Dog.gender,
#         age: rand(16),
#         animal: "Cat",
#         shelter_id: shelter_ids.sample
#   )
# end
#
# #adoptions
#
# Pet.all.each do |pet|
#   Adoption.create(
#         user_id: User.all.sample.id,
#         pet_id: pet.id,
#         adoption_date: Date.new([2018,2019].sample, rand(1..12), rand(1..28))
#   )
# end
#
# #donations
# 20.times do
#   Donation.create(
#         user_id: User.all.sample.id,
#         pet_id: Pet.all.sample.id,
#         amount: rand(10..1000)
#   )
# end

spinner.success('Done!') # Stop animation

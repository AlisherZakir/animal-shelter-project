class User < ActiveRecord::Base
  has_many :adoptions
  has_many :pets, through: :adoptions
  has_many :donations, through: :pets
  has_many :shelters, through: :pets

  def full_name
    "#{first_name} #{last_name}"
  end

  def plug_full_name(name)
    names = name.split(' ')
    hash = {
      first_name: names[0],
      last_name: names[1]
    }
  end

  def self.find_by(**hash)
    puts hash
    if hash[:name]
      names = hash[:name].split(" ")
      hash[:first_name] = names[0]
      hash[:last_name] = names[1]
      hash.delete(:name)
    end
    super(**hash)
  end
end

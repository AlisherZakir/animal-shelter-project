class User < ActiveRecord::Base
  has_many :adoptions
  has_many :pets, through: :adoptions
  has_many :donations, through: :pets
  has_many :shelters, through: :pets

  def full_name
    "#{first_name} #{last_name}"
  end
end

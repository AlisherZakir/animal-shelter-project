class User < ActiveRecord::Base
  has_many :pets, through: :adoptions
  has_many :adoptions
  has_many :donations, through: :pets
end

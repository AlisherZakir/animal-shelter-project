class Pet < ActiveRecord::Base
  has_many :users, through: :adoptions
  has_many :adoptions
  has_many :donations, through: :users
end

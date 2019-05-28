class Pet < ActiveRecord::Base
  has_many :users, through: :adoptions
  has_many :adoptions
end

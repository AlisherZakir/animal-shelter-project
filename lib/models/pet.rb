class Pet < ActiveRecord::Base
  has_one :adoption
  has_one :user, through: :adoption
  has_many :donations, through: :users
  belongs_to :shelter
end

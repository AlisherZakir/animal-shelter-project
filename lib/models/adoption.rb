class Adoption < ActiveRecord::Base
  belongs_to :pet, foreign_key: :pet_id
  belongs_to :user, foreign_key: :user_id
end

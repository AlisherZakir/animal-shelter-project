class AddIdsToAdoptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :adoptions, :user, foreign_key: true
    add_reference :adoptions, :pet, foreign_key: true
  end
end

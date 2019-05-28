class AddIdsToAdoptions < ActiveRecord::Migration[5.2]
  def change
    add_column :adoptions, :user_id, :integer
    add_column :adoptions, :pet_id, :integer
  end
end

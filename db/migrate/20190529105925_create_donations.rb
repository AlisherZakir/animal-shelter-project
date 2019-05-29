class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :pet_id
      t.integer :amount
    end
  end
end

class CreateCats < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :animal
      t.string :sex
      t.string :breed
      t.integer :age
      t.string :size
      t.string :color
      t.string :temperament
      t.integer :shelter_id
    end
  end
end

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :address
      t.boolean :workmen
      t.boolean :customer
      t.string :image_url
      t.string :email
      t.string :telephone

      t.timestamps
    end
  end
end

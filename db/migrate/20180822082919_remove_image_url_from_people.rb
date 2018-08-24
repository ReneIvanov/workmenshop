class RemoveImageUrlFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :image_url, :string
  end
end

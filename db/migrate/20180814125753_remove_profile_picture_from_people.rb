class RemoveProfilePictureFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :profile_picture, :binary
  end
end

class AddProfilePictureToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :profile_picture, :binary, :limit => 2.megabyte
  end
end

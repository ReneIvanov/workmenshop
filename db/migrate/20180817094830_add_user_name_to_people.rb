class AddUserNameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :user_name, :string
    add_column :people, :password, :string
  end
end

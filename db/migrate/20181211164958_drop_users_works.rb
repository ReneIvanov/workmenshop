class DropUsersWorks < ActiveRecord::Migration[5.2]
  def change
    drop_table :users_works
  end
end

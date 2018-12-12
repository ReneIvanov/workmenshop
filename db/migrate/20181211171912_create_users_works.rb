class CreateUsersWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :users_works do |t|
      t.belongs_to :user, index: true
      t.belongs_to :work, index: true
      t.timestamps
    end
  end
end

class CreateUsersWorksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users_works, :id => false do |t|
    	t.integer :user_id
    	t.integer :work_id
    end
  end
end

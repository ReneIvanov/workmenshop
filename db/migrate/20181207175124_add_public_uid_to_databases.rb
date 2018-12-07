class AddPublicUidToDatabases < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :public_uid, :Integer
    add_index  :users, :public_uid

    add_column :works, :public_uid, :Integer
    add_index  :works, :public_uid

    add_column :accounts, :public_uid, :Integer
    add_index  :accounts, :public_uid
  end
end

class RenamePassword < ActiveRecord::Migration[5.2]
  def change
  	rename_column :people, :password, :password_digest
  end
end

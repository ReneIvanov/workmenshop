class RenameColumnsInAccounts < ActiveRecord::Migration[5.2]
  def change
  	rename_column :accounts, :customer?, :customer
  	rename_column :accounts, :workmen?, :workmen
  	rename_column :accounts, :admin?, :admin
  end
end

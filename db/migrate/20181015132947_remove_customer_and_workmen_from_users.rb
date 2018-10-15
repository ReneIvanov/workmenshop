class RemoveCustomerAndWorkmenFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :customer, :boolean
    remove_column :users, :workmen, :boolean
  end
end

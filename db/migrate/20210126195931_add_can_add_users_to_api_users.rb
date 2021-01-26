class AddCanAddUsersToApiUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :api_users, :can_add_users, :boolean
  end
end

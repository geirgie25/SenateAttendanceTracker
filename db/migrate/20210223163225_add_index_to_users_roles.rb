class AddIndexToUsersRoles < ActiveRecord::Migration[6.1]
  def change
    add_index :roles_users, [:user_id, :role_id], :unique => true
    add_index :roles_users, :user_id

    add_index :committees_roles, [:committee_id, :role_id], :unique => true
    add_index :committees_roles, :committee_id
    
  end
end

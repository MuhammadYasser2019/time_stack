class RenameRolesUserToUserRoles < ActiveRecord::Migration[5.0]
  def change
    rename_table :roles_users, :user_roles
  end
end

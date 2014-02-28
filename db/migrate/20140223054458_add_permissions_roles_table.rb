class AddPermissionsRolesTable < ActiveRecord::Migration
  def change
    create_table :permissions_roles, :id => false do |t|
      t.integer :permission_id
      t.integer :role_id
    end
    add_index :permissions_roles, :permission_id
    add_index :permissions_roles, :role_id
  end
end

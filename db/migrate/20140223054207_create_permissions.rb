class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :model_name
      t.text :description

      t.timestamps
    end
  end
end

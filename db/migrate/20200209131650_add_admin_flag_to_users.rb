class AddAdminFlagToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false

    change_column_null :users, :admin, false
  end
end

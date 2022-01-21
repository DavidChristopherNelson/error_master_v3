class AddUserCreatedToFolders < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :user_created, :boolean
  end
end

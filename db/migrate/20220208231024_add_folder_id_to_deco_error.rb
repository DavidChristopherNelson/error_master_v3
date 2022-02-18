class AddFolderIdToDecoError < ActiveRecord::Migration[6.1]
  def change
    add_reference :deco_errors, :folder, null: false, foreign_key: true
  end
end

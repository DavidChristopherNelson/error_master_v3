class CreateMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :mappings do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :deco_error, null: false, foreign_key: true

      t.timestamps
    end
  end
end

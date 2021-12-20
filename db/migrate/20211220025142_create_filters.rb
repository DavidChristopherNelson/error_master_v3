class CreateFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :filters do |t|
      t.references :folder, null: false, foreign_key: true
      t.text :name
      t.integer :execution_order
      t.text :logic
      t.timestamps
    end
  end
end

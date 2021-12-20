class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.references :filter, null: false, foreign_key: true
      t.text :field
      t.text :value
      t.timestamps
    end
  end
end

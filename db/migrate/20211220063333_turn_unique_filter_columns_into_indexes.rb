class TurnUniqueFilterColumnsIntoIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :filters, :name, unique: true
    add_index :filters, :execution_order, unique: true
    add_index :folders, :name, unique: true    
  end
end

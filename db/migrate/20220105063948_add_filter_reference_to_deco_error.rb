class AddFilterReferenceToDecoError < ActiveRecord::Migration[6.1]
  def change
    add_reference :deco_errors, :filter, null: false, foreign_key: true
  end
end

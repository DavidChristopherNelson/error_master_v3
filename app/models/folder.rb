class Folder < ApplicationRecord
  has_many :mappings, dependent: nil
  has_many :deco_errors, through: :mappings
  belongs_to :parent, class_name: :folder, optional: true
  has_many :children,
           class_name: :folder,
           foreign_key: :parent_id,
           dependent: :destroy,
           inverse_of: :parent
end

class DecoError < ApplicationRecord
  has_many :mappings, dependent: nil
  has_many :folders, through: :mappings, dependent: nil
  belongs_to :filter
end

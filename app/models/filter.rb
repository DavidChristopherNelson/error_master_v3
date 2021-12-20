class Filter < ApplicationRecord
  has_many :deco_errors, dependent: nil
  has_many :rules, dependent: :destroy
  belongs_to :folder

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true
  validates :execution_order, uniqueness: true
end

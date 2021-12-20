class Filter < ApplicationRecord
  has_many :deco_errors, dependent: nil
  has_many :rules, dependent: :destroy
  belongs_to :folder
end

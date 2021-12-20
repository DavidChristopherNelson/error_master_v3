class Rule < ApplicationRecord
  belongs_to :filter

  validates :value, presence: true
end

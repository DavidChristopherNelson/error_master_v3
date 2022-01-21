class Rule < ApplicationRecord
  belongs_to :filter

  validates :value, presence: true

  def serialize
    serialized_form = {}
    attributes.each_key do |key|
      serialized_form[key.to_sym] = self[key]
    end
    serialized_form
  end

  def self.serialize
    serialized_form = []
    Rule.all.find_each do |rule|
      serialized_form << rule.serialize
    end
    serialized_form
  end
end

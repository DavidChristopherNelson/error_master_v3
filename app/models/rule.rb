class Rule < ApplicationRecord
  belongs_to :filter, touch: true

  validates :value, presence: true

  # Returns a cache key that is different every time a Rule
  # object is created, deleted or updated.
  #
  # @return [String] the cache key.
  def self.cache_key
    count = Rule.count
    max_updated_at = Rule.maximum(:updated_at).to_s(:number)
    "rules/#{max_updated_at}/#{count}"
  end

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

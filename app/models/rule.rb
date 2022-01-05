class Rule < ApplicationRecord
  belongs_to :filter

  validates :value, presence: true

  def serialize
    serialized_form = {}
    attributes.each_key do |key|
      serialized_form[key] = self[key]
    end
    serialized_form
  end

  def self.serialize
    serialized_form = {}
    Folder.all.find_each do |folder|
      serialized_form[folder.id.to_s] = folder.serialize
    end
    serialized_form
  end
end

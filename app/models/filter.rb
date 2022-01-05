class Filter < ApplicationRecord
  has_many :deco_errors, dependent: nil
  has_many :rules, dependent: :destroy
  belongs_to :folder

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true
  validates :execution_order, uniqueness: true

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

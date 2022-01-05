class Folder < ApplicationRecord
  has_many :mappings, dependent: nil
  has_many :deco_errors, through: :mappings
  belongs_to :parent, class_name: :folder, optional: true
  has_many :children,
           class_name: :folder,
           foreign_key: :parent_id,
           dependent: :destroy,
           inverse_of: :parent

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true

  def serialize
    serialized_form = {}
    attributes.each_key do |key|
      serialized_form[key] = self[key]
    end
    serialized_form['num_of_errors'] = deco_errors.count
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

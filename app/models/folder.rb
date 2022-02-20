class Folder < ApplicationRecord
  has_many :deco_errors
  has_one :filter, dependent: :destroy
  belongs_to :parent,
             class_name: 'Folder',
             optional: true
  has_many :children,
           class_name: 'Folder',
           foreign_key: :parent_id,
           dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true

  def self.serialize
    return_data = []
    Folder.where(parent_id: nil).find_each do |folder|
      return_data << folder.serialize
    end
    return_data
  end

  def serialize
    serialized_folder_hash = {
      name: name,
      id: id,
      user_created: user_created
    }

    serialized_children_array = []
    children.each do |child|
      serialized_children_array << child.serialize
    end
    serialized_folder_hash[:children] = serialized_children_array
    serialized_folder_hash
  end

  def self.hierarchy_order
    family_tree = []
    Folder.where(parent_id: nil).order(:created_at).find_each do |folder|
      folder.descendants(family_tree)
    end
    family_tree
  end

  def descendants(family_tree)
    family_tree << self
    children.order(:created_at).each do |child|
      child.descendants(family_tree)
    end
  end

  def self.display_info
    folder_display_info = {}
    Folder.all.find_each(batch_size: 1000) do |folder|
      folder_display_info[folder.id] = {
        num_of_ancestors: folder.count_ancestors,
        num_of_errors: folder.deco_errors.count
      }
    end
    folder_display_info
  end

  def count_ancestors
    ancestor_count = 0
    folder = self
    loop do
      parent_id = folder.parent_id
      return ancestor_count if parent_id.nil?

      folder = Folder.find(parent_id)
      return ancestor_count if folder.parent_id == parent_id

      ancestor_count += 1
    end
  end
end

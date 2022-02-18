class Filter < ApplicationRecord
  has_many :deco_errors, dependent: nil
  has_many :rules, inverse_of: :filter, dependent: :destroy
  accepts_nested_attributes_for :rules, allow_destroy: true, reject_if: :all_blank
  belongs_to :folder

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true
  validates :execution_order, uniqueness: true

  # Returns a cache key that is different every time a Filter or Rule
  # object is created, deleted or updated.
  #
  # @return [String] the cache key.
  def self.cache_key
    count = Filter.count
    max_updated_at = Filter.maximum(:updated_at).to_s(:number)
    "filters/#{max_updated_at}/#{count}"
  end

  def self.rule_engine_data
    # filters = [[nil], [nil], ...]
    filters = Filter.connection.query(
      'SELECT logic FROM filters ORDER BY execution_order'
    )
    # rules = [[232, "request_id", "ZDFAAESSD"], ...]
    rules = Rule.connection.query(
      'SELECT id, field, value FROM rules ORDER BY id'
    )
    { filter_data: filters, rule_data: rules }
  end

  def serialize
    # Serialize filter attributes.
    serialized_form = {}
    attributes.each_key do |key|
      serialized_form[key.to_sym] = self[key] unless key == 'logic'
    end

    # Serialize filter rules.
    serialized_form[:rules] = []
    rules.each do |rule|
      serialized_form[:rules] << rule.serialize
    end

    # Serialize filter logic.
    serialized_form[:logic] = get_logic(serialized_form)

    serialized_form
  end

  def self.serialize
    serialized_form = []
    Filter.order(:execution_order).each do |filter|
      serialized_form << filter.serialize
    end
    serialized_form
  end

  def self.serialize_group(filters)
    filters.to_a
    filters.sort_by!(&:execution_order)

    serialized_form = []
    filters.each do |filter|
      serialized_form << filter.serialize
    end
    serialized_form
  end

  private

  def get_logic(serialized_form)
    if logic == '' || logic.nil?
      logic = []
      serialized_form[:rules].each do |rule|
        logic << rule[:id].to_s
        logic << '&&' unless rule == serialized_form[:rules][-1]
      end
    else
      logic = self.logic
      # This code turns logic from a string into an array.
      logic.gsub!(/[^\d()&|!]/, '')
      logic.gsub!(/(\d+)/, ',\1,')
      logic.gsub!(/(&&)/, ',\1,')
      logic.gsub!(/(\|\|)/, ',\1,')
      logic.gsub!(/(!)/, ',\1,')
      logic.gsub!(/(\()/, ',\1,')
      logic.gsub!(/(\))/, ',\1,')
      logic = logic[1..-2].split(',,')
    end
    logic
  end
end

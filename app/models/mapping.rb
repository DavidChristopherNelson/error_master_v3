class Mapping < ApplicationRecord
  belongs_to :folder, inverse_of: :mappings
  belongs_to :deco_error, inverse_of: :mappings
end

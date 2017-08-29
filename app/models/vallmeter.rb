class Vallmeter < ApplicationRecord
  belongs_to :mpoint, inverse_of: :vallmeters
end

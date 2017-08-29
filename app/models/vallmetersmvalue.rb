class Vallmetersmvalue < ApplicationRecord
  belongs_to :mpoint, inverse_of: :vallmetersmvalues
end

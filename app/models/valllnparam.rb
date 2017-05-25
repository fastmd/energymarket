class Valllnparam < ApplicationRecord
  belongs_to :mpoint, inverse_of: :valllnparams
  belongs_to :line, inverse_of: :valllnparams
end

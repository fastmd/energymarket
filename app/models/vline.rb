class Vline < ApplicationRecord
  belongs_to :wire, inverse_of: :vlines
  belongs_to :mesubstation, inverse_of: :vlines
  has_many  :lnparams, inverse_of: :vline
  has_many  :mpoints, through: :lnparams, inverse_of: :vline
end

class Vallline < ApplicationRecord
  belongs_to :wire, inverse_of: :valllines
  belongs_to :mesubstation, inverse_of: :valllines
  has_many  :lnparams, inverse_of: :vallline
  has_many  :mpoints, through: :lnparams, inverse_of: :vallline
end

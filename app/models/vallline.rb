class Vallline < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :wire, inverse_of: :valllines
  belongs_to :mesubstation, inverse_of: :valllines
  has_many  :lnparams, inverse_of: :line, foreign_key: "line_id"
  has_many  :mpoints, through: :lnparams, inverse_of: :line, foreign_key: "line_id"
end

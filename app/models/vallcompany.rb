class Vallcompany < ApplicationRecord
  has_many :vallmpoints, inverse_of: :vallcompany
  has_many :vmpoints, inverse_of: :vallcompany
  has_many :meters, through: :vallmpoints, inverse_of: :vallcompany
  has_many :mvalues, through: :meters, inverse_of: :vallcompany
  has_many :furnizors, through: :vallmpoints
  has_many :filials, through: :vallmpoints
end

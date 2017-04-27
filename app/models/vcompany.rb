class Vcompany < ApplicationRecord
  has_many :vmpoints, inverse_of: :vcompany
  has_many :meters, through: :vmpoints, inverse_of: :vcompany
  has_many :mvalues, through: :meters, inverse_of: :vcompany
  has_many :furnizors, through: :vmpoints, inverse_of: :vcompany
  has_many :filials, through: :vmpoints, inverse_of: :vcompany
end

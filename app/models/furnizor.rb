class Furnizor < ApplicationRecord
  has_many :mpoints, inverse_of: :furnizor
  has_many :vmpoints, inverse_of: :furnizor
  has_many :vallmpoints, inverse_of: :furnizor
  has_many :companies, through: :mpoints, inverse_of: :furnizor
  has_many :vcompanies, through: :vmpoints, inverse_of: :furnizor
  has_many :vallcompanies, through: :vallmpoints, inverse_of: :furnizor    
end

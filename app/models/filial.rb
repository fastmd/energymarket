class Filial < ApplicationRecord
  has_many :mpoints, inverse_of: :filial, through: :mesubstations
  has_many :vmpoints, inverse_of: :filial
  has_many :vallmpoints, inverse_of: :filial
  has_many :companies, through: :mpoints, inverse_of: :filial
  has_many :vcompanies, through: :vmpoints, inverse_of: :filial
  has_many :vallcompanies, through: :vallmpoints, inverse_of: :filial
  has_many :mesubstations,  inverse_of: :filial
end

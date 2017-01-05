class Company < ApplicationRecord
  has_many :mpoints, dependent: :destroy
  has_many :meters, through: :mpoints
  has_many :mvalues, through: :meters
  belongs_to :furnizor
  belongs_to :filial
end

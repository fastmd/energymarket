class Company < ApplicationRecord
  has_many :mpoints, dependent: :destroy
  belongs_to :furnizor
  belongs_to :filial
end

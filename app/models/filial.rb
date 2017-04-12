class Filial < ApplicationRecord
  has_many :mpoints
  has_many :companys, through: :mpoints
end

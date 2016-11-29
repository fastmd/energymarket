class Filial < ApplicationRecord
  has_many :companys, dependent: :destroy
end

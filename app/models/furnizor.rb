class Furnizor < ApplicationRecord
  has_many :companys, dependent: :destroy
end

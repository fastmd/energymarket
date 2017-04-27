class Thesauru < ApplicationRecord
  has_many :meters, inverse_of: :thesauru
  has_many :mesubstations, inverse_of: :thesauru
  validates :name, presence: true
  validates :cvalue, presence: true
end

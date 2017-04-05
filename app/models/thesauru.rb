class Thesauru < ApplicationRecord
  has_many :meters
  has_many :companies
  validates :name, presence: true
  validates :cvalue, presence: true
end

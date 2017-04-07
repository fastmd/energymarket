class Thesauru < ApplicationRecord
  has_many :meters
  has_many :companies
  has_many :mpoints
  validates :name, presence: true
  validates :cvalue, presence: true
end

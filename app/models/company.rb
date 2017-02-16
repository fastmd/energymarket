class Company < ApplicationRecord
  has_many :mpoints, dependent: :destroy
  has_many :meters, through: :mpoints
  has_many :mvalues, through: :meters
  belongs_to :furnizor
  belongs_to :filial
  validates :name, presence: true
  validates :filial_id, presence: true
  validates :furnizor_id, presence: true
  validates :shname, presence: true
  validates :f, presence: true  
end

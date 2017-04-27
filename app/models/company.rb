class Company < ApplicationRecord
  has_many :mpoints, inverse_of: :company
  has_many :vmpoints, inverse_of: :company
  has_many :vallmpoints, inverse_of: :company
  has_many :meters, through: :mpoints, inverse_of: :company
  has_many :mvalues, through: :meters, inverse_of: :company
  has_many :furnizors, through: :mpoints, inverse_of: :company
  has_many :filials, through: :mpoints, inverse_of: :company
  validates :name, presence: true
  validates :shname, presence: true 
end

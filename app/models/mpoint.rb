class Mpoint < ApplicationRecord
 # has_one :linepr
 has_many :meters
 has_many :mvalues, through: :meters
 has_many :trparams, dependent: :destroy
 has_many :lineprs, dependent: :destroy  
 belongs_to :company
end

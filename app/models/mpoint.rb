class Mpoint < ApplicationRecord
 # has_one :linepr
 has_many :mvalues
 has_many :trparams, dependent: :destroy
 has_many :lineprs, dependent: :destroy
  
  belongs_to :company
end

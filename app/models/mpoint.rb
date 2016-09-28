class Mpoint < ApplicationRecord
 # has_one :linepr
 has_many :mvalues
 has_one :trparam, dependent: :destroy
 has_one :lineparam, dependent: :destroy
  
  belongs_to :company
end

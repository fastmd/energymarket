class Mpoint < ApplicationRecord
 has_many :meters
 has_many :mvalues, through: :meters
 has_many :trparams, dependent: :destroy
 has_many :lineprs, dependent: :destroy  
 belongs_to :company, counter_cache: :mpoints_count
end

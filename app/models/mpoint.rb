class Mpoint < ApplicationRecord
 has_many :meters
 has_many :mvalues, through: :meters
 has_many :trparams, dependent: :destroy
 has_many :lnparams, dependent: :destroy  
 belongs_to :company, counter_cache: :mpoints_count
 belongs_to :thesauru
 validates :name, presence: true
 validates :messtation, presence: true
 validates :meconname, presence: true
 validates :clsstation, presence: true
 validates :clconname, presence: true
 validates :voltcl, presence: true
 validates :company_id, presence: true
 validates :f, presence: true
end

class Mpoint < ApplicationRecord
 has_many   :meters, inverse_of: :mpoint
 has_many   :mvalues, through: :meters, inverse_of: :mpoint
 has_many   :trparams, inverse_of: :mpoint
 has_many   :lnparams, inverse_of: :mpoint 
 belongs_to :company, inverse_of: :mpoints, counter_cache: :mpoints_count
 belongs_to :furnizor, inverse_of: :mpoints, counter_cache: :mpoints_count
 belongs_to :mesubstation, inverse_of: :mpoints
 belongs_to :filial, inverse_of: :mpoints, counter_cache: :mpoints_count
 belongs_to :region, inverse_of: :mpoints
 validates  :name, presence: true
 validates  :mesubstation_id, presence: true
 validates  :meconname, presence: true
 validates  :clsstation, presence: true
 validates  :clconname, presence: true
 validates  :voltcl, presence: true
 validates  :company_id, presence: true
 validates  :furnizor_id, presence: true
 validates  :f, presence: true
end

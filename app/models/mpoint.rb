class Mpoint < ApplicationRecord
 has_many   :mproperties, inverse_of: :mpoint
 has_many   :meters, inverse_of: :mpoint
 has_many   :vallmeters, inverse_of: :mpoint
 has_many   :vallmetersmvalues, inverse_of: :mpoint
 has_many   :mvalues, through: :meters, inverse_of: :mpoint
 has_many   :trparams, inverse_of: :mpoint
 has_many   :transformators, through: :trparams, inverse_of: :mpoint
 has_many   :lnparams, inverse_of: :mpoint
 has_many   :vlnparams, inverse_of: :mpoint
 has_many   :valllnparams, inverse_of: :mpoint
 has_many   :lines, through: :lnparams, inverse_of: :mpoint
 has_many   :valllines, through: :lnparams, inverse_of: :mpoint
 has_many   :minputs, inverse_of: :mpoint
 belongs_to :company, inverse_of: :mpoints, counter_cache: :mpoints_count
 belongs_to :furnizor, inverse_of: :mpoints, counter_cache: :mpoints_count
 belongs_to :mesubstation, inverse_of: :mpoints
 validates  :name, presence: true, allow_blank: false, length: { in: 3..30 }
 validates  :mesubstation_id, presence: true, numericality: { only_integer: true }
 validates  :meconname, presence: true
 validates  :clsstation, presence: true
 validates  :clconname, presence: true
 validates  :voltcl, presence: true, numericality: {:greater_than_or_equal_to => (0.4), :less_than_or_equal_to => 35}
 validates  :company_id, presence: true, numericality: { only_integer: true }
 validates  :furnizor_id, presence: true, numericality: { only_integer: true }
 validates  :cod, presence: false, numericality: { only_integer: true }, allow_blank: true
 
 #before_validation :stripblank

  def stripblank
    if !self.name.nil? then self.name = mylrstreep(self.name) end
    return true
  end
end

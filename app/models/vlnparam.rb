class Vlnparam < ApplicationRecord
  belongs_to :mpoint, inverse_of: :vlnparams
  belongs_to :line,   inverse_of: :vlnparams
  belongs_to :vline,   inverse_of: :vlnparams  
end

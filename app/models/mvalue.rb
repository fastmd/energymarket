class Mvalue < ApplicationRecord
  belongs_to :meter, inverse_of: :mvalues
  belongs_to :mpoint, inverse_of: :mvalues  
end

class Region < ApplicationRecord
  self.table_name = "public.thesaurus"
  has_many :mesubstations, inverse_of: :region
  has_many :vallmpoints, inverse_of: :region
end

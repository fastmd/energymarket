class Vallmpointsproperty < ApplicationRecord
  belongs_to :vallcompany, inverse_of: :vallmpoints, class_name: "Vallcompany", foreign_key: "company_id"
  belongs_to :furnizor, inverse_of: :vallmpoints
  belongs_to :mesubstation, inverse_of: :vallmpoints
  belongs_to :filial, inverse_of: :vallmpoints
  belongs_to :region, inverse_of: :vallmpoints
end

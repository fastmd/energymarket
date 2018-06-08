class Vmpoint < ApplicationRecord
  belongs_to :vallcompany, inverse_of: :vmpoints, class_name: "Vallcompany", foreign_key: "company_id"
  belongs_to :vcompany, inverse_of: :vmpoints, class_name: "Vcompany", foreign_key: "company_id"
  belongs_to :furnizor, inverse_of: :vmpoints
  belongs_to :mesubstation, inverse_of: :vmpoints
  belongs_to :filial, inverse_of: :vmpoints
  belongs_to :region, inverse_of: :vmpoints
end

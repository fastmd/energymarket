class Vallmesubstation < ApplicationRecord
  belongs_to :filial, -> { order('name') }, inverse_of: :vallmesubstations, foreign_key: "filial_id"
  belongs_to :region, -> { where(name: 'region', f: true).order('cvalue') }, class_name: "Region", inverse_of: :vallmesubstations, foreign_key: "region_id"
  has_many   :mpoints, inverse_of: :vallmesubstation
  has_many   :vallmpoints, inverse_of: :vallmesubstation
  has_many   :lines, inverse_of: :vallmesubstation
end

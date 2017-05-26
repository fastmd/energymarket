class Vmesubstation < ApplicationRecord
  belongs_to :filial, -> { order('name') }, inverse_of: :vmesubstations, foreign_key: "filial_id"
  belongs_to :region, -> { where(name: 'region', f: true).order('cvalue') }, class_name: "Region", inverse_of: :vmesubstations, foreign_key: "region_id"
  has_many   :mpoints, inverse_of: :vmesubstation
  has_many   :vallmpoints, inverse_of: :vmesubstation
  has_many   :lines, inverse_of: :vmesubstation
end

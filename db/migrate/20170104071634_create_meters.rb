class CreateMeters < ActiveRecord::Migration[5.0]
  def change
    create_table :meters do |t|
      t.string   "metertype"
      t.integer  "meternum"
      t.string   "koeftt"
      t.string   "koeftn"
      t.integer  "koefcalc"
      t.belongs_to :mpoint, index: true
      t.timestamps
    end
  end
end

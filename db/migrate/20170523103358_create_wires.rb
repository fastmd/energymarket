class CreateWires < ActiveRecord::Migration[5.0]
  def change
    create_table :wires do |t|
      t.string   "name"
      t.decimal  "ro",         precision: 10, scale: 4               
      t.decimal  "k_scr",      precision: 10, scale: 4               
      t.decimal  "k_peb",      precision: 10, scale: 4               
      t.decimal  "q",          precision: 10, scale: 4               
      t.boolean  "f",                                   default: true
      t.text     "comment"
      t.timestamps
    end
  end
end

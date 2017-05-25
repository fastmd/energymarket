class CreateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :lines do |t|
      t.string   "name"
      t.decimal  "l",          precision: 10, scale: 4                  
      t.decimal  "r",          precision: 14, scale: 8                  
      t.decimal  "k_tr",       precision: 10, scale: 4, default: "1.03"  
      t.decimal  "k_f",        precision: 10, scale: 4, default: "1.15"
      t.integer  "line_id"                                              
      t.integer  "mesubstation_id"                                      
      t.boolean  "f",                                   default: true
      t.text     "comment"     
      t.timestamps
    end
  end
end

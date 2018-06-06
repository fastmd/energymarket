class CreateMproperties < ActiveRecord::Migration[5.0]
  def change
    create_table :mproperties do |t|
      t.decimal  "voltcl",           precision: 14, scale: 4, default: "10.0", null: false      
      t.boolean  "fct",              default: false,  null: false
      t.decimal  "cosfi",            precision: 3,  scale: 2
      t.boolean  "fctc"
      t.boolean  "four"
      t.boolean  "fturn"
      t.boolean  "fctl"
      t.boolean  "fmargin"
      t.boolean  "fminuslinelosses"    
      t.references :mpoint, foreign_key: true
      t.boolean  "f",                default: true  
      t.text     "comment"
      t.timestamps
    end
  end
end

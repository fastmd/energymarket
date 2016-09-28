class AddMeterPoints < ActiveRecord::Migration[5.0]
  def change
    
    create_table :mpoints do |t|
      t.integer :pnum
      t.string :pname
      t.belongs_to :company, index: true
      
      t.timestamps null: false
    end
  end
end

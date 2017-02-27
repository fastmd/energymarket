class CreateTaus < ActiveRecord::Migration[5.0]
  def change
    create_table :taus do |t|
      t.integer :tm, :null => false
      t.integer :taum, :null => false

      t.timestamps
    end
  end
end

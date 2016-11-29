class CreateFilials < ActiveRecord::Migration[5.0]
  def change
    create_table :filials do |t|
      t.string :name
      t.integer :cod_id
      t.text :comment

      t.timestamps
    end
  end
end

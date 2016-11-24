class CreateFurnizors < ActiveRecord::Migration[5.0]
  def change
    create_table :furnizors do |t|
      t.string :name
      t.string :cod_id
      t.text :comment

      t.timestamps
    end
  end
end

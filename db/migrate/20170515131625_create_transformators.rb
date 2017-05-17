class CreateTransformators < ActiveRecord::Migration[5.0]
  def change
    create_table :transformators do |t|
      t.string :name
      t.decimal :pxx
      t.decimal :pkz
      t.decimal :snom
      t.decimal :ukz
      t.decimal :i0
      t.decimal :qkz
      t.text :comment
      t.boolean :f

      t.timestamps
    end
  end
end

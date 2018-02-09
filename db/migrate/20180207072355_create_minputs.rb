class CreateMinputs < ActiveRecord::Migration[5.0]
  def change
    create_table :minputs do |t|
      t.decimal :tlosses, precision: 10, scale: 2
      t.decimal :llosses, precision: 10, scale: 2
      t.decimal :ct, precision: 10, scale: 2
      t.boolean :f, default: true
      t.date :mdate, null: false
      t.text :comment
    end
  end
end

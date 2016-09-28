class CreateMvalues < ActiveRecord::Migration[5.0]
  def change
    create_table :mvalues do |t|
      t.integer :vnum
      t.float :val
      t.text :comment
      t.belongs_to :mpoint, index: true
      t.timestamps
    end
  end
end

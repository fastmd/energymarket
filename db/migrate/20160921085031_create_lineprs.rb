class CreateLineprs < ActiveRecord::Migration[5.0]
  def change
    create_table :lineprs do |t|
      t.float :l1
      t.float :l2
      t.float :p1
      t.float :p2
t.belongs_to :mpoint, index: true
      t.timestamps
    end
  end
end

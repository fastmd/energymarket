class CreateLineparams < ActiveRecord::Migration[5.0]
  def change
    create_table :lineparams do |t|
      t.float :r1
      t.float :r2
      t.float :l1
      t.float :l2
      t.belongs_to :mpoint, index: true
      t.timestamps
    end
  end
end

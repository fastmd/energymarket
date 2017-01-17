class DelLineprsCols < ActiveRecord::Migration[5.0]
  def change
    remove_column :lineprs, :l2
    remove_column :lineprs, :p2
  end
end

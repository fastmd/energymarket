class AddLineprsColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :lineprs, :comment, :text
  end
end

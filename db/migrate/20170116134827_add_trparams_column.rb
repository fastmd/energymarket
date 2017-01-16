class AddTrparamsColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :trparams, :comment, :text
  end
end

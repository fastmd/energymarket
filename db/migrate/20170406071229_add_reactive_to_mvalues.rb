class AddReactiveToMvalues < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :actr580, :decimal, :precision => 14, :scale => 4
    add_column :mvalues, :actr880, :decimal, :precision => 14, :scale => 4
  end
end

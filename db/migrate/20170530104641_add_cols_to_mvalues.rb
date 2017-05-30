class AddColsToMvalues < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :trab, :integer
    add_column :mvalues, :dwa, :decimal, :precision => 20, :scale => 4 
  end
end

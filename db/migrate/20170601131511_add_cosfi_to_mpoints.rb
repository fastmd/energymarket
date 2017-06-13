class AddCosfiToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :cosfi, :decimal, :precision => 3, :scale => 2 
  end
end

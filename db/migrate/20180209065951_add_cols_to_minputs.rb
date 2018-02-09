class AddColsToMinputs < ActiveRecord::Migration[5.0]
  def change
    add_column :minputs, :tplosses, :decimal, :precision => 10, :scale => 2
    rename_column :minputs, :tlosses, :trlosses
    add_column :minputs, :cti, :decimal, :precision => 10, :scale => 2
    rename_column :minputs, :ct, :ctc      
  end
end

class AddMvaluesUndercount < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :undercount, :decimal, :precision => 20, :scale => 4 
  end
end

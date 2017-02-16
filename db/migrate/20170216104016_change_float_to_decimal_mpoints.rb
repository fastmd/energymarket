class ChangeFloatToDecimalMpoints < ActiveRecord::Migration[5.0]
  def change
     change_column :mpoints, :voltcl, :decimal, :precision => 14, :scale => 4    
  end
end

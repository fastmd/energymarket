class ChangeColumnsTransformators < ActiveRecord::Migration[5.0]
  def change
     change_column :transformators, :pxx, :decimal, :precision => 10, :scale => 4
     change_column :transformators, :pkz, :decimal, :precision => 10, :scale => 4
     change_column :transformators, :snom, :decimal, :precision => 10, :scale => 4
     change_column :transformators, :ukz, :decimal, :precision => 10, :scale => 4
     change_column :transformators, :i0, :decimal, :precision => 10, :scale => 4
     change_column :transformators, :qkz, :decimal, :precision => 14, :scale => 8
     change_column_null    :transformators, :pxx, false
     change_column_null    :transformators, :pkz, false
     change_column_null    :transformators, :snom, false
     change_column_null    :transformators, :ukz, false
     change_column_null    :transformators, :i0, false
     change_column_null    :transformators, :qkz, false
     change_column_null    :transformators, :f, false
     change_column_null    :transformators, :name, false        
     change_column_default :transformators, :f, true 
  end
end

class ChangeFloatToDecimalTrparams < ActiveRecord::Migration[5.0]
  def change
     change_column :trparams, :pxx, :decimal, :precision => 10, :scale => 4
     change_column :trparams, :pkz, :decimal, :precision => 10, :scale => 4
     change_column :trparams, :snom, :decimal, :precision => 10, :scale => 4
     change_column :trparams, :ukz, :decimal, :precision => 10, :scale => 4
     change_column :trparams, :io, :decimal, :precision => 10, :scale => 4
     change_column :trparams, :qkz, :decimal, :precision => 14, :scale => 8
     change_column_null    :trparams, :pxx, false
     change_column_null    :trparams, :pkz, false
     change_column_null    :trparams, :snom, false
     change_column_null    :trparams, :ukz, false
     change_column_null    :trparams, :io, false
     change_column_null    :trparams, :qkz, false
     change_column_null    :trparams, :f, false     
     change_column_default :trparams, :f, true       
  end
end

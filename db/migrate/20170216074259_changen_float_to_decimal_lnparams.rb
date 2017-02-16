class ChangenFloatToDecimalLnparams < ActiveRecord::Migration[5.0]
  def change
     change_column :lnparams, :r, :decimal, :precision => 14, :scale => 8
     change_column :lnparams, :ro, :decimal, :precision => 10, :scale => 4
     change_column :lnparams, :k_scr, :decimal, :precision => 10, :scale => 4
     change_column :lnparams, :k_tr, :decimal, :precision => 10, :scale => 4
     change_column :lnparams, :k_peb, :decimal, :precision => 10, :scale => 4
     change_column :lnparams, :q, :decimal, :precision => 10, :scale => 4
     change_column :lnparams, :k_f, :decimal, :precision => 10, :scale => 4
     change_column_null    :lnparams, :l, false
     change_column_null    :lnparams, :r, false
     change_column_null    :lnparams, :ro, false
     change_column_null    :lnparams, :k_scr, false
     change_column_null    :lnparams, :k_tr, false
     change_column_null    :lnparams, :k_peb, false
     change_column_null    :lnparams, :q, false
     change_column_null    :lnparams, :k_f, false
     change_column_default :lnparams, :k_f, 1.15 
     change_column_null    :lnparams, :f, false     
     change_column_default :lnparams, :f, true          
  end
end

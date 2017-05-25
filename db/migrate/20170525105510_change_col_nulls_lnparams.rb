class ChangeColNullsLnparams < ActiveRecord::Migration[5.0]
  def change
        change_column_null    :lnparams, :l, false
        change_column_null    :lnparams, :r, false 
        change_column_null    :lnparams, :ro, false 
        change_column_null    :lnparams, :k_scr, false 
        change_column_null    :lnparams, :k_tr, false 
        change_column_null    :lnparams, :k_f, false 
        change_column_null    :lnparams, :q, false 
        change_column_null    :lnparams, :k_peb, false  
  end
end

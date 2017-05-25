class Change1ColNullsLnparams < ActiveRecord::Migration[5.0]
  def change
        change_column_null    :lnparams, :l, true
        change_column_null    :lnparams, :r, true 
        change_column_null    :lnparams, :ro, true 
        change_column_null    :lnparams, :k_scr, true 
        change_column_null    :lnparams, :k_tr, true 
        change_column_null    :lnparams, :k_f, true 
        change_column_null    :lnparams, :q, true 
        change_column_null    :lnparams, :k_peb, true
  end
end

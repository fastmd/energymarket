class DropColsLnparams < ActiveRecord::Migration[5.0]
  def change
        remove_column    :lnparams, :l, :decimal
        remove_column    :lnparams, :r, :decimal 
        remove_column    :lnparams, :ro, :decimal 
        remove_column    :lnparams, :k_scr, :decimal 
        remove_column    :lnparams, :k_tr, :decimal 
        remove_column    :lnparams, :k_f, :decimal 
        remove_column    :lnparams, :q, :decimal 
        remove_column    :lnparams, :k_peb, :decimal
  end
end

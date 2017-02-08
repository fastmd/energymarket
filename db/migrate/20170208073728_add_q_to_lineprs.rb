class AddQToLineprs < ActiveRecord::Migration[5.0]
  def change
    rename_table :lineprs, :lnparams
    add_column :lnparams, :ro, :float
    add_column :lnparams, :k_scr, :float
    add_column :lnparams, :k_tr, :float
    add_column :lnparams, :k_peb, :float
    add_column :lnparams, :q, :float
    rename_column :lnparams, :l1, :l
    rename_column :lnparams, :p1, :r
  end
end

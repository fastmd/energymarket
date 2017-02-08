class AddKfToLnparams < ActiveRecord::Migration[5.0]
  def change
    add_column :lnparams, :k_f, :float
    add_foreign_key  :lnparams, :mpoints
    add_foreign_key  :trparams, :mpoints
  end
end

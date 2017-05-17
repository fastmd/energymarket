class Drop1ColsTrparams < ActiveRecord::Migration[5.0]
  def change
    remove_column :trparams, :pxx, :decimal
    remove_column :trparams, :pkz, :decimal
    remove_column :trparams, :snom, :decimal 
    remove_column :trparams, :ukz, :decimal 
    remove_column :trparams, :io, :decimal
    remove_column :trparams, :qkz, :decimal
    remove_column :trparams, :mark, :string
    change_column_null    :trparams, :transformator_id, false     
  end
end

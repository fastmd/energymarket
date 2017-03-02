class ChangeTrparamsAddMark < ActiveRecord::Migration[5.0]
  def change
    remove_column :trparams, :type, :string
    remove_column :lnparams, :type, :string
    add_column :trparams, :mark, :string
    add_column :lnparams, :mark, :string
  end
end

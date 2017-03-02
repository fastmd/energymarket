class ChangeMpointsAddCod < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :cod, :integer
    add_column :trparams, :type, :string
    add_column :lnparams, :type, :string
  end
end

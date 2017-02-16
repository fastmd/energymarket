class ChangeFloatToDecimalLnparamss < ActiveRecord::Migration[5.0]
  def change
    change_column :lnparams, :l, :decimal, :precision => 10, :scale => 4
  end
end

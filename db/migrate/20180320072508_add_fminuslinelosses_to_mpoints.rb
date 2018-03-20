class AddFminuslinelossesToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fminuslinelosses, :boolean
  end
end

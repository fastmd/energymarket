class AddCondateToLnparams < ActiveRecord::Migration[5.0]
  def change
    add_column :lnparams, :condate, :date 
  end
end

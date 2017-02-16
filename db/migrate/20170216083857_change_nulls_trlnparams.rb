class ChangeNullsTrlnparams < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :trparams, :mpoint_id, false
    change_column_null    :lnparams, :mpoint_id, false      
  end
end

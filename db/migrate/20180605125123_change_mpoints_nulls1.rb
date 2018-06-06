class ChangeMpointsNulls1 < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mpoints, :mesubstation_id, false
  end
end

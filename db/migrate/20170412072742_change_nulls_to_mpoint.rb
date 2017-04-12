class ChangeNullsToMpoint < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mpoints, :furnizor_id, false
    change_column_null    :mpoints, :filial_id, false
  end
end

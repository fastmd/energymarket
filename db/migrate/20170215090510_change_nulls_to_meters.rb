class ChangeNullsToMeters < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :meters, :koeftt, false
    change_column_default :meters, :koeftt, '1 / 1'
  end
end

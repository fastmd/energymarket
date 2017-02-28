class ChangeMvaluesR < ActiveRecord::Migration[5.0]
  def change
    change_column_default :mvalues, :r, true
    change_column_null    :mvalues, :r, false
  end
end

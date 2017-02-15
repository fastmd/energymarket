class ChangeNullsDefaultsToMvalues < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mvalues, :actp180, false
    change_column_null    :mvalues, :actp280, false
    change_column_null    :mvalues, :actp380, false
    change_column_null    :mvalues, :actp480, false
    change_column_null    :mvalues, :actdate, false   
    change_column_null    :mvalues, :meter_id, false
    change_column_null    :mvalues, :f, false
    change_column_default :mvalues, :f, true     
  end
end

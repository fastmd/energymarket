class ChangeNullsActpToMvalues < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mvalues, :actp180, true
    change_column_null    :mvalues, :actp280, true
    change_column_null    :mvalues, :actp380, true
    change_column_null    :mvalues, :actp480, true     
  end
end

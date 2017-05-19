class Ch1NullsToMvalues < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mvalues, :actp180, false
    change_column_null    :mvalues, :actp280, false 
    change_column_null    :mvalues, :actp380, false 
    change_column_null    :mvalues, :actp480, false  
  end
end

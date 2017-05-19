class Add2FlagToMpoints < ActiveRecord::Migration[5.0]
  def change
    change_column_default :mpoints, :fct, true 
    change_column_null    :mpoints, :fct, false
  end
end

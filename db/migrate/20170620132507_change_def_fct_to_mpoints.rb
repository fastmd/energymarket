class ChangeDefFctToMpoints < ActiveRecord::Migration[5.0]
  def change
    change_column_default :mpoints, :fct, false
  end
end

class ChangeMesubstationsDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:mesubstations, :name, nil)
  end
end

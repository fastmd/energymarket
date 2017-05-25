class InsertDataToLines < ActiveRecord::Migration[5.0]
  def change
      rename_column :lines, :line_id, :wire_id   
  end
end

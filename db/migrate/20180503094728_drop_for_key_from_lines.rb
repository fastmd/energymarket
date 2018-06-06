class DropForKeyFromLines < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :lines, column: :mesubstation2_id
  end
end

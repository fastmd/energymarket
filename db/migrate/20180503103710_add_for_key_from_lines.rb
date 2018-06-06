class AddForKeyFromLines < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key "lines", "mesubstations", column: :mesubstation2_id
  end
end
